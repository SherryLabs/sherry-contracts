import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SL1MessageSenderModule = buildModule("SL1MessageSenderModule", (m) => {
    // Origin-Chain Wormhole Relayer Address
    const whRelayerAddress = "0xA3cF45939bD6260bcFe3D66bc73d60f19e49a8BB";

    const sender = m.contract("SL1MessageSender", [whRelayerAddress], {});
    return { sender };
});

export default SL1MessageSenderModule;