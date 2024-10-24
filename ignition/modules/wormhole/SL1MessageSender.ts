import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SL1MessageSenderModule = buildModule("SL1MessageSenderModule", (m) => {
    // Destination-Chain Wormhole Relayer Address
    const whRelayerAddress = "0x306B68267Deb7c5DfCDa3619E22E9Ca39C374f84";

    const sender = m.contract("SL1MessageSender", [whRelayerAddress], {});
    return { sender };
});

export default SL1MessageSenderModule;