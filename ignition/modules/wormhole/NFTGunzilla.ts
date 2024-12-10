import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const NFTGunzillaModule = buildModule("NFTGunzillaModule", (m) => {
    const nftGunzilla = m.contract("NFTGunzilla", [], {});
    return { nftGunzilla };
});

export default NFTGunzillaModule;