import {
    ChainId,
    WNATIVE,
    Token,
    TokenAmount,
    Percent,
} from "@traderjoe-xyz/sdk-core";
import {
    PairV2,
    RouteV2,
    TradeV2,
    TradeOptions,
    LB_ROUTER_V22_ADDRESS,
    jsonAbis,
} from "@traderjoe-xyz/sdk-v2";
import {
    createPublicClient,
    createWalletClient,
    http,
    parseUnits,
    BaseError,
    ContractFunctionRevertedError,
    WalletClient,
    PublicClient,
} from "viem";
import { privateKeyToAccount } from "viem/accounts";
import { avalancheFuji } from "viem/chains";
import { config } from "dotenv";
import path from 'path';
import * as fs from 'fs';
config();

// initialize tokens
const ROUTER = "0x431850c483cAb3E2e497B05c3C9430daf0B6c3A6";
const CHAIN_ID = ChainId.FUJI;
const TOKENS = {
    "WAVAX": WNATIVE[CHAIN_ID],
    "USDT": new Token(
        CHAIN_ID,
        "0x175Ba38E41Eb22E98f1DA5f0166EF52e811505F2",
        6,
        "USDT",
        "Theter"
    ),
    "USDC": new Token(
        CHAIN_ID,
        "0x4c0D40C6DBb3Ccc016EfE0506Ff5bb6ceA83DC99",
        6,
        "USDC",
        "USD Coin"
    ),
};

const erc20Abi = [
    {
        name: 'allowance',
        type: 'function',
        inputs: [
            { name: 'owner', type: 'address' },
            { name: 'spender', type: 'address' }
        ],
        outputs: [{ name: '', type: 'uint256' }],
        stateMutability: 'view'
    },
    {
        name: 'approve',
        type: 'function',
        inputs: [
            { name: 'spender', type: 'address' },
            { name: 'amount', type: 'uint256' }
        ],
        outputs: [{ name: '', type: 'bool' }],
        stateMutability: 'nonpayable'
    }
];

type tokens = "WAVAX" | "USDT" | "USDC";

export const checkAndApproveToken = async (
    token: tokens,
    amountNeeded: string,
    publicClient: PublicClient,
    walletClient: WalletClient,
) => {
    try {
        const inputToken = TOKENS[token];
        // Convert the amount to the correct unit with decimals
        const typedValueInParsed = parseUnits(amountNeeded, inputToken.decimals);
        const account = walletClient.account;
        const accountAddress = walletClient.account?.address as string;
        // Verify the current allowance
        const currentAllowance = await publicClient.readContract({
            address: `0x${inputToken.address.slice(2)}`,
            abi: erc20Abi,
            functionName: 'allowance',
            args: [accountAddress, ROUTER]
        }) as bigint;

        console.log(`Current allowance: ${currentAllowance}`);

        // Check if we need to approve
        if (currentAllowance < typedValueInParsed) {
            console.log('Insufficient allowance, sending approval...');
            // Send the approve transaction
            const hash = await walletClient.writeContract({
                address: `0x${inputToken.address.slice(2)}`,
                abi: erc20Abi,
                functionName: 'approve',
                args: [ROUTER, typedValueInParsed],
                chain: avalancheFuji,
                account: account || null
            });

            console.log(`Approval transaction sent: ${hash}`);

            // Optional: Wait for the transaction to be confirmed
            const receipt = await publicClient.waitForTransactionReceipt({ hash });
            console.log('Approval confirmed:', receipt.status === 'success');

            return receipt.status === 'success';
        } else {
            console.log('Sufficient allowance, no approval needed');
            return true;
        }
    } catch (error) {
        console.error('Error verifying or approving tokens:', error);
        throw error;
    }
}

export const execute = async (
    input: tokens,
    output: tokens,
    isExactIn: boolean,
    typedValueIn: string,
    isNativeIn: boolean,
    isNativeOut: boolean,
    publicClient: PublicClient,
    walletClient: WalletClient,
) => {
    try {
        // Initialize variables
        // -------------------------------------------------------------------------
        //const router = LB_ROUTER_V22_ADDRESS[CHAIN_ID];
        //const { LBRouterV22ABI: abi } = jsonAbis;

        const KOLSwapRouterV2 = JSON.parse(
            fs.readFileSync(
                path.resolve(
                    __dirname,
                    '../../artifacts/contracts/kol-router/KOLSwapRouterV2.sol/KOLSwapRouterV2.json'
                ),
                'utf8'
            )
        );
        if (!KOLSwapRouterV2) {
            throw new Error("Before start, compile contracts: yarn compile");
        }
        const abi = KOLSwapRouterV2.abi;

        // Declare user inputs
        // -------------------------------------------------------------------------
        // declare bases used to generate trade routes
        const BASES = [TOKENS[input], TOKENS[output]];
        // the input token in the trade
        const inputToken = TOKENS[input];
        // the output token in the trade
        const outputToken = TOKENS[output];
        // parse user input into inputToken's decimal precision, which is 18 for WAVAX
        const typedValueInParsed = parseUnits(typedValueIn, inputToken.decimals);
        // wrap into TokenAmount
        const amountIn = new TokenAmount(inputToken, typedValueInParsed);
        const account = walletClient.account;

        // Generate all possible routes
        // -------------------------------------------------------------------------
        // get all [Token, Token] combinations
        const allTokenPairs = PairV2.createAllTokenPairs(
            inputToken,
            outputToken,
            BASES
        );
        // init PairV2 instances for the [Token, Token] pairs
        const allPairs = PairV2.initPairs(allTokenPairs);
        // generates all possible routes to consider
        const allRoutes = RouteV2.createAllRoutes(allPairs, inputToken, outputToken);

        // Generate TradeV2 instances and get the best trade
        // -------------------------------------------------------------------------
        // generates all possible TradeV2 instances
        const trades = await TradeV2.getTradesExactIn(
            allRoutes,
            amountIn,
            outputToken,
            isNativeIn,
            isNativeOut,
            publicClient,
            CHAIN_ID
        );

        // chooses the best trade
        const bestTrade = TradeV2.chooseBestTrade(
            trades.filter((t): t is TradeV2 => t !== undefined),
            isExactIn
        );

        // Check trade information
        // -------------------------------------------------------------------------
        if (bestTrade) {
            // get trade fee information
            const { totalFeePct, feeAmountIn } = await bestTrade.getTradeFee();
            console.log("Best trade: ", bestTrade.toLog());
            console.log("Total fees percentage", totalFeePct.toSignificant(6), "%");
            console.log(`Fee: ${feeAmountIn.toSignificant(6)} ${feeAmountIn.token.symbol}`);

            // Declare slippage tolerance and swap method/parameters
            // -----------------------------------------------------------------
            // set slippage tolerance
            const userSlippageTolerance = new Percent("50", "10000"); // 0.5%

            // set swap options
            const accountAddress = walletClient.account?.address as string;
            const swapOptions: TradeOptions = {
                allowedSlippage: userSlippageTolerance,
                ttl: 3600,
                recipient: accountAddress,
                feeOnTransfer: false, // or true
            };

            // generate swap method and parameters for contract call
            const {
                methodName, // e.g. swapExactNATIVEforToken,
                args, // e.g.[amountIn, amountOut, (pairBinSteps, versions, tokenPath) to, deadline]
                value, // e.g. 0.1 eth in hex: 0x16345785d8a0000
            } = bestTrade.swapCallParameters(swapOptions);

            // add KOL router fee!
            const fixedFeeAmount = await publicClient.readContract({
                address: ROUTER,
                abi,
                functionName: 'fixedFeeAmount',
                args: [],
            }) as bigint;
            const valuePlusFee = BigInt(value) + fixedFeeAmount;

            // Execute trade
            // -----------------------------------------------------------------
            const { request } = await publicClient.simulateContract({
                address: ROUTER,
                abi,
                functionName: methodName,
                args,
                account,
                value: valuePlusFee,
            });

            const hash = await walletClient.writeContract(request);
            console.log(`Transaction sent: https://testnet.snowtrace.io/tx/${hash}`);
        } else {
            throw new Error("Some token has no liquidity");
        }
    } catch (error) {
        throw error;
    }
}
