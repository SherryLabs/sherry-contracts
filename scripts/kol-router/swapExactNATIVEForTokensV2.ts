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
} from "viem";
import { privateKeyToAccount } from "viem/accounts";
import { avalancheFuji } from "viem/chains";
import { config } from "dotenv";
import path from 'path';
import * as fs from 'fs';
config();



async function main() {

    try {


        // Initialize variables
        // -------------------------------------------------------------------------
        const privateKey = process.env.DEPLOYER_KEY as string;
        const account = privateKeyToAccount(`0x${privateKey.slice(2)}`);
        const CHAIN_ID = ChainId.FUJI;

        //const router = LB_ROUTER_V22_ADDRESS[CHAIN_ID];
        //const { LBRouterV22ABI: abi } = jsonAbis;

        const router = "0x431850c483cAb3E2e497B05c3C9430daf0B6c3A6";
        const KOLSwapRouterV2 = JSON.parse(
            fs.readFileSync(
                path.resolve(__dirname, '../../artifacts/contracts/kol-router/KOLSwapRouterV2.sol/KOLSwapRouterV2.json'),
                'utf8'
            )
        );
        if (!KOLSwapRouterV2) {
            throw new Error("Before start, compile contracts: yarn compile");
        }
        const abi = KOLSwapRouterV2.abi;

        // Initialize clients
        // -------------------------------------------------------------------------
        const publicClient = createPublicClient({
            chain: avalancheFuji,
            transport: http(),
        });
        const walletClient = createWalletClient({
            account,
            chain: avalancheFuji,
            transport: http(),
        });

        // initialize tokens
        // -------------------------------------------------------------------------
        const WAVAX = WNATIVE[CHAIN_ID]; // Token instance of WAVAX
        const USDC = new Token(
            CHAIN_ID,
            "0x4c0D40C6DBb3Ccc016EfE0506Ff5bb6ceA83DC99",
            6,
            "USDC",
            "USD Coin"
        );
        // declare bases used to generate trade routes
        const BASES = [WAVAX, USDC];


        // Declare user inputs
        // -------------------------------------------------------------------------
        // the input token in the trade
        const inputToken = WAVAX;
        // the output token in the trade
        const outputToken = USDC;
        // specify whether user gave an exact inputToken or outputToken value for the trade
        const isExactIn = true;
        // user string input; in this case representing 0.1 WAVAX
        const typedValueIn = "0.1";
        // parse user input into inputToken's decimal precision, which is 18 for WAVAX
        const typedValueInParsed = parseUnits(typedValueIn, inputToken.decimals);
        // wrap into TokenAmount
        const amountIn = new TokenAmount(inputToken, typedValueInParsed);


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
        const isNativeIn = true;
        const isNativeOut = false;

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
            // ---------------------------------------------------------------------
            // set slippage tolerance
            const userSlippageTolerance = new Percent("50", "10000"); // 0.5%

            // set swap options
            const swapOptions: TradeOptions = {
                allowedSlippage: userSlippageTolerance,
                ttl: 3600,
                recipient: account.address,
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
                address: router,
                abi,
                functionName: 'fixedFeeAmount',
                args: [],
            }) as bigint;
            const valuePlusFee = BigInt(value) + fixedFeeAmount;

            // Execute trade
            // ---------------------------------------------------------------------
            const { request } = await publicClient.simulateContract({
                address: router,
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

main().catch((error) => {
    console.error('Script error:', error);
});
