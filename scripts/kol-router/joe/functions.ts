import {
    ChainId,
    WNATIVE,
    Token,
    TokenAmount,
    Percent,
} from "@traderjoe-xyz/sdk-core";
import { PairV2, RouteV2, TradeV2, TradeOptions } from "@traderjoe-xyz/sdk-v2";
import { parseUnits, WalletClient, PublicClient } from "viem";
import { avalancheFuji } from "viem/chains";
import path from 'path';
import * as fs from 'fs';

const KOL_ROUTER = "0xC723ff604E1ce13a5e7d7bc5CcA2b76E3A61946b"; // TODO: take this from .env

// initialize tokens
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

export const createKolRouter = async (
    kolAddress: string,
    walletClient: WalletClient
) => {
    const account = walletClient.account;
    const KOLFactoryJoe = JSON.parse(
        fs.readFileSync(
            path.resolve(
                __dirname,
                '../../../artifacts/contracts/kol-router/KOLFactoryTraderJoe.sol/KOLFactoryTraderJoe.json'
            ),
            'utf8'
        )
    );

    if (!KOLFactoryJoe) {
        throw new Error("Before start, compile contracts: yarn compile");
    }

    const deployedAddresses = JSON.parse(
        fs.readFileSync(
            path.resolve(
                __dirname,
                '../../../ignition/deployments/chain-43113/deployed_addresses.json'
            ),
            'utf8'
        )
    );

    if (!deployedAddresses["KOLFactoryTraderJoeModule#KOLFactoryTraderJoe"]) {
        throw new Error("Before start, deploy factory contract: yarn deploy:koltraderjoe");
    }

    const abi = KOLFactoryJoe.abi;
    const tx = await walletClient.writeContract({
        address: deployedAddresses["KOLFactoryTraderJoeModule#KOLFactoryTraderJoe"],
        abi,
        functionName: 'createKOLRouter',
        args: [kolAddress],
        chain: avalancheFuji,
        account: account || null
    });
    console.log(`KolRouter successfully created: https://testnet.snowtrace.io/tx/${tx}`);
}

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
            args: [accountAddress, KOL_ROUTER]
        }) as bigint;

        console.log(`Current allowance: ${currentAllowance}`);

        // Check if we need to approve
        if (currentAllowance < typedValueInParsed) {
            console.log('Insufficient allowance, sending approval...');
            // Send the approve transaction
            const tx = await walletClient.writeContract({
                address: `0x${inputToken.address.slice(2)}`,
                abi: erc20Abi,
                functionName: 'approve',
                args: [KOL_ROUTER, typedValueInParsed],
                chain: avalancheFuji,
                account: account || null
            });

            console.log(`Transaction sent: https://testnet.snowtrace.io/tx/${tx}`);

            // Wait for the transaction to be confirmed
            const receipt = await publicClient.waitForTransactionReceipt({ hash: tx });
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
        const KOLRouterTraderJoe = JSON.parse(
            fs.readFileSync(
                path.resolve(
                    __dirname,
                    '../../../artifacts/contracts/kol-router/KOLRouterTraderJoe.sol/KOLRouterTraderJoe.json'
                ),
                'utf8'
            )
        );
        if (!KOLRouterTraderJoe) {
            throw new Error("Before start, compile contracts: yarn compile");
        }
        const abi = KOLRouterTraderJoe.abi;

        // Declare user inputs
        // -------------------------------------------------------------------------
        // declare bases used to generate trade routes
        const BASES = [TOKENS[input], TOKENS[output]];
        const inputToken = TOKENS[input];
        const outputToken = TOKENS[output];
        const typedValueInParsed = parseUnits(typedValueIn, inputToken.decimals);

        console.log("typedValueInParsed", typedValueInParsed)

        // calculate net amount
        const netAmount = await publicClient.readContract({
            address: KOL_ROUTER,
            abi,
            functionName: 'calculateNetAmount',
            args: [typedValueInParsed],
        }) as bigint;

        console.log("netAmount", netAmount)

        const amountIn = new TokenAmount(inputToken, netAmount);
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
            const slippage = new Percent("50", "10000"); // 0.5%

            // set swap options
            const accountAddress = walletClient.account?.address as string;
            const swapOptions: TradeOptions = {
                allowedSlippage: slippage,
                ttl: 3600,
                recipient: accountAddress,
                feeOnTransfer: false, // or true
            };

            // generate swap method and parameters for contract call
            let {
                methodName, // e.g. swapExactNATIVEforToken,
                args, // e.g.[amountIn, amountOut, (pairBinSteps, versions, tokenPath) to, deadline]
                value, // e.g. 0.1 eth in hex: 0x16345785d8a0000
            } = bestTrade.swapCallParameters(swapOptions);

            if (isNativeIn) {
                value = typedValueInParsed.toString();
            } else {
                args[0] = typedValueInParsed.toString();
            }

            // Execute trade
            // -----------------------------------------------------------------
            const { request } = await publicClient.simulateContract({
                address: KOL_ROUTER,
                abi,
                functionName: methodName,
                args,
                account,
                value: BigInt(value),
            });

            const hash = await walletClient.writeContract(request);
            console.log(`Transaction sent: https://testnet.snowtrace.io/tx/${hash}`);
        } else {
            throw new Error("No route found — Some token has no liquidity");
        }
    } catch (error) {
        throw error;
    }
}
