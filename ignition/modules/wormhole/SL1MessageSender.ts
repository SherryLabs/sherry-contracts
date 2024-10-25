import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { chains } from "../../../utils/chains";

const SL1MessageSenderModule = buildModule("SL1MessageSenderModule", (m) => {

    const fujiChain = chains.find((chain) => chain.name === "avalancheFuji");
    const celoChain = chains.find((chain) => chain.name === "celoAlfajores");

    // Origin-Chain Wormhole Relayer Address
    const whRelayerAddress = fujiChain?.wormholeRelayer;

    if (!whRelayerAddress) {
        throw new Error("WH_RELAYER_ADDRESS is required");
    }

    // Deploy SL1MessageSender contract in Fuji
    const sender = m.contract("SL1MessageSender", [whRelayerAddress], {});
    return { sender };
});

export default SL1MessageSenderModule;