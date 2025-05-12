import { execute } from "./functions";
import { createPublicClient, createWalletClient, http } from "viem";
import { privateKeyToAccount } from "viem/accounts";
import { avalancheFuji } from "viem/chains";

const INPUT_TOKEN = "WAVAX";
const OUTPUT_TOKEN = "USDT";
const IS_EXACT_IN = true;
const DECIMAL_VALUE_IN = "0.1";
const NATIVE_IN = true;
const NATIVE_OUT = false;

async function main() {
    try {
        const privateKey = process.env.DEPLOYER_KEY as string;
        const account = privateKeyToAccount(`0x${privateKey.slice(2)}`);
        // Initialize clients
        // ---------------------------------------------------------------------
        const publicClient = createPublicClient({
            chain: avalancheFuji,
            transport: http(),
        });
        const walletClient = createWalletClient({
            account,
            chain: avalancheFuji,
            transport: http(),
        });

        await execute(
            INPUT_TOKEN,
            OUTPUT_TOKEN,
            IS_EXACT_IN,
            DECIMAL_VALUE_IN,
            NATIVE_IN,
            NATIVE_OUT,
            publicClient,
            walletClient,
        )
    } catch (error) {
        throw error;
    }
}

main().catch((error) => {
    console.error('Script error:', error);
});
