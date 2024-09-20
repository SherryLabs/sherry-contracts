import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const BrandModule = buildModule("BrandModule", (m) => {
    const brand = m.contract("Brand", [], { });

    const campaign = m.contract("Campaign", [brand], { });

    return { brand, campaign };
})

export default BrandModule;