import { executeSwap } from './functions.pangolin';

const INPUT_TOKEN = "PNG";
const OUTPUT_TOKEN = "WAVAX";
const DECIMAL_VALUE_IN = "0.001";
const NATIVE_IN = false;
const NATIVE_OUT = true;

async function main() {
    await executeSwap(
        INPUT_TOKEN,
        OUTPUT_TOKEN,
        DECIMAL_VALUE_IN,
        NATIVE_IN,
        NATIVE_OUT
    );
}

main().catch((error) => {
    console.error('Error in script:', error);
});
