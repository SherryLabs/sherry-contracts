import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { chains } from "../../../utils/chains";

const SL1MessageReceiverModule = buildModule("SL1MessageReceiverModule", (m) => {

    const celoChain = chains.find((chain) => chain.name === "celoAlfajores");
    // Destination-Chain Wormhole Relayer Address
    // Example: Celo Alfajores
    const whRelayerAddress = "0x306B68267Deb7c5DfCDa3619E22E9Ca39C374f84"

    if (!whRelayerAddress) {
        throw new Error("WH_RELAYER_ADDRESS is required");
    }

    const receiver = m.contract("SL1MessageReceiver", [whRelayerAddress], {});
    return { receiver };
});

export default SL1MessageReceiverModule;