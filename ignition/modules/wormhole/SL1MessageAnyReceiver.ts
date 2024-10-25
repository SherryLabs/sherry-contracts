import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SL1MessageAnyReceiverModule = buildModule("SL1MessageAnyReceiverModule", (m) => {
    // Destination-Chain Wormhole Relayer Address
    // Example: Celo Alfajores
    const whRelayerAddress = "0x306B68267Deb7c5DfCDa3619E22E9Ca39C374f84"

    if (!whRelayerAddress) {
        throw new Error("WH_RELAYER_ADDRESS is required");
    }

    const receiver = m.contract("SL1MessageAnyReceiver", [whRelayerAddress], {});
    return { receiver };
});

export default SL1MessageAnyReceiverModule;