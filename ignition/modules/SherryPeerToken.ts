import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SherryPeerTokenModule = buildModule("SherryPeerTokenModule", (m) => {
    const owner = m.getAccount(0);
    const tokenAmount = 10000000000000000000000000;

    const sherryPeerToken = m.contract("SherryPeerToken", [
        "Sherry",
        "SHERRY",
        owner,
        owner,
    ], {});

    const txMint = m.call(sherryPeerToken, "mint", [owner, BigInt(tokenAmount)]);
    //console.log("txMint", txMint);

    return { sherryPeerToken };
}
);

export default SherryPeerTokenModule;