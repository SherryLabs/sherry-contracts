import path from 'path';
import * as fs from 'fs';
import { PublicClient, WalletClient, parseUnits, createPublicClient, createWalletClient, http, decodeFunctionData, encodeFunctionData, parseGwei } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { avalanche } from 'viem/chains';
import { Token, CurrencyAmount, Percent, TradeType, Ether } from '@uniswap/sdk-core';
import { UniversalRouterVersion } from '@uniswap/universal-router-sdk';
import { AlphaRouter, SwapType } from '@uniswap/smart-order-router';
import { JsonRpcProvider } from '@ethersproject/providers';

const KOL_ROUTER = '0x4BfB9798Bf3960f02599eae756e735eDC6ACc7b2'; // TODO: take this from .env
const CHAIN_ID = 43114; // Avalanche Mainnet

let publicClient: PublicClient;
let walletClient: WalletClient;

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


//TODO: move to utils
function decimalPercentToPercent(decimalPercent: number, precision: number = 6): Percent {
    const actualDecimal = decimalPercent / 100;
    const denominator = 10 ** precision;
    const numerator = Math.round(actualDecimal * denominator);
    return new Percent(numerator, denominator);
}

export const createKolRouter = async (
    kolAddress: string,
    fee: string,
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

    const deployedAddresses = JSON.parse(
        fs.readFileSync(
            path.resolve(
                __dirname,
                '../../../ignition/deployments/chain-43114/deployed_addresses.json'
            ),
            'utf8'
        )
    );

    if (!deployedAddresses["KOLFactoryUniswapModule#KOLFactoryUniswap"]) {
        throw new Error("Before start, deploy factory contract: yarn deploy:koljoe");
    }

    const abi = KOLFactoryUniswap.abi;
    const tx = await walletClient.writeContract({
        address: deployedAddresses["KOLFactoryUniswapModule#KOLFactoryUniswap"],
        abi,
        functionName: 'createKOLRouter',
        args: [kolAddress, fee],
        chain: avalanche,
        account: account || null
    });
    console.log(`KolRouter successfully created: https://snowtrace.io/tx/${tx}`);
}

export const checkAndApproveToken = async (
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

        const spender = KOL_ROUTER;

        // Check current allowance
        const currentAllowance = await publicClient.readContract({
            address: `0x${inputToken.address.slice(2)}`,
            abi: erc20Abi,
            functionName: 'allowance',
            args: [accountAddress, spender],
        }) as bigint;

        console.log(`Current allowance: ${currentAllowance}`);
        console.log(`Amount to be approved: ${typedValueInParsed}`);

        if (currentAllowance < typedValueInParsed) {
            console.log(`Insufficient allowance, sending approval...`);
            const tx = await walletClient.writeContract({
                address: `0x${inputToken.address.slice(2)}`,
                abi: erc20Abi,
                functionName: 'approve',
                args: [spender, typedValueInParsed],
                chain: avalanche,
                account: account || null,
            });

            console.log(`Approval TX: https://snowtrace.io/tx/${tx}`);
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
};

const executeUniswapSwap = async (
    input: tokens,
    output: tokens,
    typedValueIn: string,
    nativeIn: boolean,
    nativeOut: boolean,
    decimalSlippage: string,
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
        let inputToken, outputToken;
        if (nativeIn) {
            inputToken = Ether.onChain(CHAIN_ID);
            outputToken = TOKENS[output];
        } else if (nativeOut) {
            inputToken = TOKENS[input];
            outputToken = Ether.onChain(CHAIN_ID);
        } else {
            inputToken = TOKENS[input];
            outputToken = TOKENS[output];
        }

        const account = walletClient.account?.address as `0x${string}`;

        const provider = new JsonRpcProvider(
            "https://avalanche-c-chain-rpc.publicnode.com"
        );
        const router = new AlphaRouter({
            chainId: CHAIN_ID,
            provider,
            weth9: TOKENS['WAVAX'],
        } as any);

        const typedValueInParsed = parseUnits(typedValueIn, inputToken.decimals);
        const amountIn = CurrencyAmount.fromRawAmount(
            inputToken,
            typedValueInParsed.toString()
        );

        const slippage = decimalPercentToPercent(Number(decimalSlippage));
        console.log(`Slippage: ${slippage.toFixed()}%`);

        console.log("Searching route...")
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
        console.log("Route found", route);
        console.log("Value without fee:", Number(value))

        // add KOL router fee!
        const fixedFeeAmount = await publicClient.readContract({
            address: KOL_ROUTER,
            abi,
            functionName: 'fixedFeeAmount',
            args: [],
        }) as bigint;
        const valuePlusFee = BigInt(value) + fixedFeeAmount;
        console.log("Value with fee:", Number(valuePlusFee));

        // Execute trade
        // -----------------------------------------------------------------
        // Decode calldata to operate on KOLRouter
        const decoded = decodeFunctionData({
            abi: [{
                name: 'execute',
                type: 'function',
                inputs: [
                    { name: 'commands', type: 'bytes' },
                    { name: 'inputs', type: 'bytes[]' },
                    { name: 'deadline', type: 'uint256' },
                ],
            }],
            data: calldata as `0x${string}`,
        });
        const [commands, inputs, deadline] = decoded.args as [
            `0x${string}`,
            `0x${string}[]`,
            bigint
        ];

        let tx;
        if (nativeIn) {
            tx = await walletClient.writeContract({
                account: walletClient.account!,
                chain: avalanche,
                address: KOL_ROUTER,
                abi,
                functionName: 'executeNATIVEIn',
                args: [
                    commands,               // bytes
                    inputs,                 // bytes[]
                    deadline,               // bigint
                ],
                value: valuePlusFee
            });
        } else {
            tx = await walletClient.writeContract({
                account: walletClient.account!,
                chain: avalanche,
                address: KOL_ROUTER,
                abi,
                functionName: 'executeTokenIn',
                args: [
                    commands,               // bytes
                    inputs,                 // bytes[]
                    deadline,               // bigint
                    inputToken.address,     // string
                    typedValueInParsed      // bigint
                ],
                value: valuePlusFee
            });
        }
        console.log(`Transaction sent: https://snowtrace.io/tx/${tx}`);

        //const txRequest = await walletClient.prepareTransactionRequest({
        //    account: walletClient.account!,
        //    to: KOL_ROUTER,
        //    chain: avalanche,
        //    data: encodeFunctionData({
        //        abi,
        //        functionName: 'executeTokenIn',
        //        args: [commands, inputs, deadline, inputToken.address, typedValueInParsed],
        //    }),
        //    value: valuePlusFee,
        //    gas: 500000n, // estimativo, podés ajustar
        //    maxFeePerGas: parseGwei('50'),
        //    maxPriorityFeePerGas: parseGwei('2'),
        //});
        //const signedTx = await walletClient.signTransaction(txRequest);
        //console.log(signedTx)
    } catch (error) {
        throw error;
    }
};

export const executeSwap = async (
    input: tokens,
    output: tokens,
    typedValueIn: string,
    nativeIn: boolean,
    nativeOut: boolean,
    decimalSlippage: string,
) => {
    const privateKey = process.env.DEPLOYER_KEY as string;
    const account = privateKeyToAccount(`0x${privateKey.slice(2)}`);
    // Initialize clients
    // ---------------------------------------------------------------------
    publicClient = createPublicClient({
        chain: avalanche,
        transport: http(),
    });

    walletClient = createWalletClient({
        account,
        chain: avalanche,
        transport: http(),
    });

    if (!nativeIn) {
        await checkAndApproveToken(
            input,
            typedValueIn,
            publicClient,
            walletClient
        );
    }

    await executeUniswapSwap(
        input,
        output,
        typedValueIn,
        nativeIn,
        nativeOut,
        decimalSlippage
    );
};