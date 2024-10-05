import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ProtocolModule = buildModule("ProtocolModule", (m) => {
    const brand = m.contract("Brand", [], {})
    const campaign = m.contract("Campaign", [brand], {})
    const kol = m.contract("KOL", [campaign], {})
    const sherry = m.contract("Sherry", [brand, campaign, kol], {})

    return { brand, campaign, kol, sherry }
})

export default ProtocolModule;