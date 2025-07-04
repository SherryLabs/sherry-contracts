import { execute, checkAndApproveToken } from "./functions";
import { createPublicClient, createWalletClient, http } from "viem";
import { privateKeyToAccount } from "viem/accounts";
import { avalancheFuji } from "viem/chains";

const INPUT_TOKEN = "USDC";
const OUTPUT_TOKEN = "WAVAX";
const IS_EXACT_IN = true;
const DECIMAL_VALUE_IN = "1";
const NATIVE_IN = false;
const NATIVE_OUT = true;

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

        const success = await checkAndApproveToken(
            INPUT_TOKEN,
            DECIMAL_VALUE_IN,
            publicClient,
            walletClient
        );

        if (success) {
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
        }
    } catch (error) {
        throw error;
    }
}

main().catch((error) => {
    console.error('Script error:', error);
});
