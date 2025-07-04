import { executeSwap } from './functions.pangolin';

const INPUT_TOKEN = "PNG";
const OUTPUT_TOKEN = "JAWZ";
const DECIMAL_VALUE_IN = "0.00001";
const NATIVE_IN = false;
const NATIVE_OUT = false;

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
