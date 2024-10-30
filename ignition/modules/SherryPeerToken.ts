import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SherryPeerTokenModule = buildModule("SherryPeerTokenModule", (m) => {
    const owner = m.getAccount(0);
    console.log("owner", owner);

    const sherryPeerToken = m.contract("SherryPeerToken", [
        "Sherry",
        "SHERRY",
        owner,
        owner,
    ], {});

    const txMint = m.call(sherryPeerToken, "mint", [owner, 1000000]);
    console.log("txMint", txMint);

    return { sherryPeerToken };
}
);

export default SherryPeerTokenModule;