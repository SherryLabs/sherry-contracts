import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const KOLFactoryUniswapModule = buildModule("KOLFactoryUniswapModule", (m) => {
    const uniRouter: string = process.env.UNI_ROUTER || "";

    const kolFactory = m.contract("KOLFactoryUniswap", [uniRouter], {});
    return { kolFactory };
});

export default KOLFactoryUniswapModule;