import { checkAndApproveTokenUniswap, executeUniswapSwap } from './functions';
import { createPublicClient, createWalletClient, http } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { avalanche } from 'viem/chains';

const INPUT_TOKEN = "WAVAX";
const OUTPUT_TOKEN = "USDC";
const DECIMAL_VALUE_IN = "0.001";
const NATIVE_IN = true;
const NATIVE_OUT = false;

async function main() {
    const privateKey = process.env.DEPLOYER_KEY as string;
    const account = privateKeyToAccount(`0x${privateKey.slice(2)}`);
    // Initialize clients
    // ---------------------------------------------------------------------
    const publicClient = createPublicClient({
        chain: avalanche,
        transport: http(),
    });

    const walletClient = createWalletClient({
        account,
        chain: avalanche,
        transport: http(),
    });

    if (!NATIVE_IN) {
        await checkAndApproveTokenUniswap(
            INPUT_TOKEN,
            DECIMAL_VALUE_IN,
            publicClient,
            walletClient
        );
    }

    await executeUniswapSwap(
        INPUT_TOKEN,
        OUTPUT_TOKEN,
        DECIMAL_VALUE_IN,
        NATIVE_IN,
        publicClient,
        walletClient
    );
}

main().catch((error) => {
    console.error('Error in script:', error);
});
