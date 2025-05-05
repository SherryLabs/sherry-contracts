import path from 'path';
import * as fs from 'fs';
import { PublicClient, WalletClient } from 'viem';
import { avalanche } from 'viem/chains';
import { Token, CurrencyAmount, Percent, TradeType, Ether } from '@uniswap/sdk-core';
import { parseUnits } from 'viem';
import { Abi } from 'abitype';
import { PERMIT2_ADDRESS } from '@uniswap/permit2-sdk';
import { UniversalRouterVersion } from '@uniswap/universal-router-sdk';
import { AlphaRouter, SwapType } from '@uniswap/smart-order-router';
import { JsonRpcProvider } from '@ethersproject/providers';

const KOL_FACTORY = '0x933Da277d2947634605DBCaE7587952700AedE59'; // TODO: take this from .env
const KOL_ROUTER = '0x41811815AF98378B5ceed4E69a9A3d4Fe1608b4b'; // TODO: take this from .env
const CHAIN_ID = 43114; // Avalanche Mainnet

// initialize tokens
export const TOKENS = {
    "WAVAX": new Token(
        CHAIN_ID,
        '0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7',
        18,
        'WAVAX',
        'Wrapped AVAX'
    ),
    "USDC": new Token(
        CHAIN_ID,
        '0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E',
        6,
        'USDC',
        'USD Coin'
    ),
};

type tokens = "WAVAX" | "USDC";

const ERC20_ABI: Abi = [
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

export const createKolRouter = async (
    kolAddress: string,
    walletClient: WalletClient
) => {
    const account = walletClient.account;
    const KOLFactoryUniswap = JSON.parse(
        fs.readFileSync(
            path.resolve(
                __dirname,
                '../../../artifacts/contracts/kol-router/KOLFactoryUniswap.sol/KOLFactoryUniswap.json'
            ),
            'utf8'
        )
    );
    if (!KOLFactoryUniswap) {
        throw new Error("Before start, compile contracts: yarn compile");
    }

    const abi = KOLFactoryUniswap.abi;
    const tx = await walletClient.writeContract({
        address: KOL_FACTORY,
        abi,
        functionName: 'createKOLRouter',
        args: [kolAddress],
        chain: avalanche,
        account: account || null
    });
    console.log(`KolRouter successfully created: https://snowtrace.io/tx/${tx}`);
}

export const checkAndApproveTokenUniswap = async (
    token: tokens,
    amountNeeded: string,
    publicClient: PublicClient,
    walletClient: WalletClient,
) => {
    try {
        const inputToken = TOKENS[token];
        const typedValueInParsed = parseUnits(amountNeeded, inputToken.decimals);
        const account = walletClient.account;
        const accountAddress = walletClient.account?.address as string;

        const currentAllowance = await publicClient.readContract({
            address: inputToken.address as `0x${string}`,
            abi: ERC20_ABI,
            functionName: 'allowance',
            args: [accountAddress, PERMIT2_ADDRESS],
        }) as bigint;

        console.log(`Current allowance Permit2: ${currentAllowance}`);

        if (currentAllowance < typedValueInParsed) {
            console.log('Insufficient allowance, approving Permit2...');
            const tx = await walletClient.writeContract({
                address: inputToken.address as `0x${string}`,
                abi: ERC20_ABI,
                functionName: 'approve',
                args: [PERMIT2_ADDRESS, typedValueInParsed],
                chain: avalanche,
                account: account || null
            });
            console.log(`Approved Permit2: https://snowtrace.io/tx/${tx}`);

            // Wait for the transaction to be confirmed
            const receipt = await publicClient.waitForTransactionReceipt({ hash: tx });
            console.log('Approval confirmed:', receipt.status === 'success');

            return receipt.status === 'success';
        } else {
            console.log('Sufficient allowance, no approval needed');
        }
    } catch (error) {
        console.error('Error verifying or approving tokens:', error);
        throw error;
    }
};

export const executeUniswapSwap = async (
    input: tokens,
    output: tokens,
    typedValueIn: string,
    nativeIn: boolean,
    publicClient: PublicClient,
    walletClient: WalletClient,
) => {
    try {
        // Initialize variables
        // -------------------------------------------------------------------------
        const KOLRouterUniswap = JSON.parse(
            fs.readFileSync(
                path.resolve(
                    __dirname,
                    '../../../artifacts/contracts/kol-router/KOLRouterUniswap.sol/KOLRouterUniswap.json'
                ),
                'utf8'
            )
        );
        if (!KOLRouterUniswap) {
            throw new Error("Before start, compile contracts: yarn compile");
        }
        const abi = KOLRouterUniswap.abi;


        // TODO: get tokens from here https://tokens.coingecko.com/avalanche/all.json
        let inputToken;
        if (nativeIn) {
            inputToken = Ether.onChain(CHAIN_ID);
        } else {
            inputToken = TOKENS[input];
        }
        const outputToken = TOKENS[output];
        const account = walletClient.account?.address as `0x${string}`;

        const provider = new JsonRpcProvider(
            "https://avalanche.drpc.org"
        );
        const router = new AlphaRouter({
            chainId: CHAIN_ID,
            provider,
        });

        const typedValueInParsed = parseUnits(typedValueIn, inputToken.decimals);
        const amountIn = CurrencyAmount.fromRawAmount(
            inputToken,
            typedValueInParsed.toString()
        );

        const slippage = new Percent("50", "10000"); // 0.5%

        const route = await router.route(
            amountIn,
            outputToken,
            TradeType.EXACT_INPUT,
            {
                type: SwapType.UNIVERSAL_ROUTER,
                version: UniversalRouterVersion.V2_0,
                recipient: account,
                slippageTolerance: slippage,
                deadlineOrPreviousBlockhash: Math.floor(Date.now() / 1000) + 1800,
            }
        );

        if (!route || !route.methodParameters) {
            throw new Error("No route found — the AlphaRouter could not build a path.");
        }

        const { calldata, value } = route.methodParameters;

        // add KOL router fee!
        const fixedFeeAmount = await publicClient.readContract({
            address: KOL_ROUTER,
            abi,
            functionName: 'fixedFeeAmount',
            args: [],
        }) as bigint;
        const valuePlusFee = BigInt(value) + fixedFeeAmount;

        // Execute trade
        // -----------------------------------------------------------------
        // If the eth_call of .call does not revert, it means it is ok to be sent. Maybe it is better to use estimateGas.
        await publicClient.call({
            account: walletClient.account,
            to: KOL_ROUTER,
            data: calldata as `0x${string}`,
            value: BigInt(valuePlusFee),
        })

        const tx = await walletClient.sendTransaction({
            account: walletClient.account!,
            chain: avalanche,
            to: KOL_ROUTER,
            data: calldata as `0x${string}`,
            value: valuePlusFee,
        });

        console.log(`Transaction sent: https://snowtrace.io/tx/${tx}`);
    } catch (error) {
        throw error;
    }
};