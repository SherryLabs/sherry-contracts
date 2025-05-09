import { executeSwap } from './functions';

const INPUT_TOKEN = "USDC";
const OUTPUT_TOKEN = "WAVAX";
const DECIMAL_VALUE_IN = "0.0003";
const NATIVE_IN = false;
const NATIVE_OUT = true;
const SLIPPAGE = "0.5";

async function main() {
    await executeSwap(
        INPUT_TOKEN,
        OUTPUT_TOKEN,
        DECIMAL_VALUE_IN,
        NATIVE_IN,
        NATIVE_OUT,
        SLIPPAGE
    );
}

main().catch((error) => {
    console.error('Error in script:', error);
});
