import {
    ChainId,
    Token,
    TokenAmount,
    Trade,
    TradeType,
    Route,
    Percent,
    Fetcher
} from "@pangolindex/sdk";
import {
    createWalletClient,
    createPublicClient,
    http,
    encodeFunctionData,
    getAddress,
    PublicClient,
    WalletClient,
    parseUnits,
    Account
} from "viem";
import { avalancheFuji } from "viem/chains";
import { privateKeyToAccount } from "viem/accounts";
import { JsonRpcProvider } from "@ethersproject/providers";
import path from 'path';
import * as fs from 'fs';

const { FUJI_PANGOLIN_KOL_ROUTER } = process.env;

let publicClient: PublicClient;
let walletClient: WalletClient;

export const TOKENS = {
    "WAVAX": new Token(
        ChainId.FUJI,
        getAddress('0xd00ae08403b9bbb9124bb305c09058e32c39a48c'),
        18,
        'WAVAX',
        'Wrapped AVAX'
    ),
    "PNG": new Token(
        ChainId.FUJI,
        getAddress('0xAF5D473b3f8F96A5B21c6bbB97e09b491335acb9'),
        18,
        'PNG',
        'Pangolin Coin'
    ),
    "JAWZ": new Token(
        ChainId.FUJI,
        getAddress('0x0a8c21858aC24e1305BaFBDdf4DfB73a2CC9ddBC'),
        18,
        'JAWZ',
        'JAWZ Token'
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

type tokens = "WAVAX" | "PNG" | "JAWZ";

//TODO: move to utils
function decimalPercentToPercent(decimalPercent: number, precision: number = 6): Percent {
    const actualDecimal = decimalPercent / 100;
    const denominator = 10 ** precision;
    const numerator = Math.round(actualDecimal * denominator);
    return new Percent(numerator, denominator);
}

function getSwapFunction(nativeIn: boolean, nativeOut: boolean) {
    if (nativeIn && !nativeOut) {
        return 'swapExactAVAXForTokens';
    } else if (!nativeIn && nativeOut) {
        return 'swapExactTokensForAVAX';
    } else {
        return 'swapExactTokensForTokens';
    }

}

export const createKolRouter = async (
    kolAddress: string,
    walletClient: WalletClient
) => {
    const account = walletClient.account;
    const KOLFactoryJoe = JSON.parse(
        fs.readFileSync(
            path.resolve(
                __dirname,
                '../../../artifacts/contracts/kol-router/KOLFactoryPangolin.sol/KOLFactoryPangolin.json'
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

    if (!deployedAddresses["KOLFactoryPangolinModule#KOLFactoryPangolin"]) {
        throw new Error("Before start, deploy factory contract: yarn deploy:koljoe");
    }

    const abi = KOLFactoryJoe.abi;
    const tx = await walletClient.writeContract({
        address: deployedAddresses["KOLFactoryPangolinModule#KOLFactoryPangolin"],
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
            args: [accountAddress, FUJI_PANGOLIN_KOL_ROUTER]
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
                args: [FUJI_PANGOLIN_KOL_ROUTER, typedValueInParsed],
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

export const findViableRoute = async (
    inputToken: Token,
    outputToken: Token,
    provider: JsonRpcProvider
): Promise<Route> => {
    const WAVAX = TOKENS["WAVAX"];

    // 1. Try direct pair
    try {
        const directPair = await Fetcher.fetchPairData(inputToken, outputToken, provider);
        return new Route([directPair], inputToken, outputToken);
    } catch (e) {
        console.warn("No direct pair found:", (e as Error).message);
    }

    // 2. Try via WAVAX
    try {
        const firstLeg = await Fetcher.fetchPairData(inputToken, WAVAX, provider);
        const secondLeg = await Fetcher.fetchPairData(WAVAX, outputToken, provider);
        return new Route([firstLeg, secondLeg], inputToken, outputToken);
    } catch (e) {
        console.warn("No multi-hop route via WAVAX:", (e as Error).message);
    }

    throw new Error(`No viable route found from ${inputToken.symbol} to ${outputToken.symbol}`);
};

const executePangolinSwap = async (
    input: tokens,
    output: tokens,
    typedValueIn: string,
    nativeIn: boolean,
    nativeOut: boolean
) => {
    // Initialize variables
    // -------------------------------------------------------------------------
    const KOLRouterPangolin = JSON.parse(
        fs.readFileSync(
            path.resolve(
                __dirname,
                '../../../artifacts/contracts/kol-router/KOLRouterPangolinV2.sol/KOLRouterPangolinV2.json'
            ),
            'utf8'
        )
    );
    if (!KOLRouterPangolin) {
        throw new Error("Before start, compile contracts: yarn compile");
    }
    const abi = KOLRouterPangolin.abi;

    // Declare user inputs
    // -------------------------------------------------------------------------
    // declare bases used to generate trade routes
    const inputToken = TOKENS[input];
    const outputToken = TOKENS[output];

    const account = walletClient.account as Account;
    const accountAddress = walletClient.account?.address as `0x${string}`;

    const provider = new JsonRpcProvider("https://api.avax-test.network/ext/bc/C/rpc");
    const route = await findViableRoute(inputToken, outputToken, provider);
    const swapPath = route.path.map(token => token.address);
    const typedValueInParsed = parseUnits(typedValueIn, inputToken.decimals);

    console.log("typedValueInParsed", typedValueInParsed)

    // calculate net amount
    const netAmount = await publicClient.readContract({
        address: FUJI_PANGOLIN_KOL_ROUTER as `0x${string}`,
        abi,
        functionName: 'calculateNetAmount',
        args: [typedValueInParsed],
    }) as bigint;

    console.log("netAmount", netAmount)

    const amountIn = new TokenAmount(inputToken, netAmount.toString());

    const trade = new Trade(
        route,
        amountIn,
        TradeType.EXACT_INPUT
    );

    // Declare slippage tolerance and swap method/parameters
    // -----------------------------------------------------------------
    // set slippage tolerance
    const slippage = new Percent("50", "10000"); // 0.5%

    // set swap options
    const amountOutMin = trade
        .minimumAmountOut(slippage)
        .raw.toString();
    const deadline = BigInt(Math.floor(Date.now() / 1000) + 600);

    let args = [
        amountOutMin,
        swapPath,
        accountAddress,
        deadline
    ];

    if (!nativeIn) {
        args = [typedValueInParsed, ...args]
    }

    const data = encodeFunctionData({
        abi,
        functionName: getSwapFunction(nativeIn, nativeOut),
        args
    });

    // add KOL router fee!
    const value = nativeIn ? typedValueInParsed : BigInt(0);

    const gasPrice = await publicClient.getGasPrice();
    const gas = await publicClient.estimateGas({
        account,
        to: FUJI_PANGOLIN_KOL_ROUTER as `0x${string}`,
        data,
        value,
    });
    const hash = await walletClient.sendTransaction({
        account,
        to: FUJI_PANGOLIN_KOL_ROUTER as `0x${string}`,
        value,
        data,
        gas,
        gasPrice,
        chain: avalancheFuji,
    });
    console.log(`Swap successs: https://testnet.snowtrace.io/tx/${hash}`);
}

export const executeSwap = async (
    input: tokens,
    output: tokens,
    typedValueIn: string,
    nativeIn: boolean,
    nativeOut: boolean,
) => {
    const privateKey = process.env.DEPLOYER_KEY as string;
    const account = privateKeyToAccount(`0x${privateKey.slice(2)}`);
    // Initialize clients
    // ---------------------------------------------------------------------
    publicClient = createPublicClient({
        chain: avalancheFuji,
        transport: http(),
    });

    walletClient = createWalletClient({
        account,
        chain: avalancheFuji,
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

    await executePangolinSwap(
        input,
        output,
        typedValueIn,
        nativeIn,
        nativeOut
    );
};