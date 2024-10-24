import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SL1MessageAnyReceiverModule = buildModule("SL1MessageAnyReceiverModule", (m) => {
    // Origin-Chain Wormhole Relayer Address
    const whRelayerAddress = "0xA3cF45939bD6260bcFe3D66bc73d60f19e49a8BB"

    if (!whRelayerAddress) {
        throw new Error("WH_RELAYER_ADDRESS is required");
    }

    const receiver = m.contract("SL1MessageAnyReceiver", [whRelayerAddress], {});
    return { receiver };
});

export default SL1MessageAnyReceiverModule;