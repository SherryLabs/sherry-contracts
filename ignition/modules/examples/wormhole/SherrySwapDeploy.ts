import { buildModule } from "@nomicfoundation/hardhat-ignition/modules"

const SherrySwapDeploy = buildModule("SherrySwapDeploy", (m) => {

    // SherryToken address - 18 decimals
    const tokenA = "0x075f8Af6c27a570b4c8A94BaE72f878fc98721a5"
    // USDC Address - 6 decimals
    const tokenB = "0x2F25deB3848C207fc8E0c34035B3Ba7fC157602B"

    const sherrySwap = m.contract("SherrySwap",
        [tokenA, tokenB]
        , {});

    return { sherrySwap };
});

export default SherrySwapDeploy;