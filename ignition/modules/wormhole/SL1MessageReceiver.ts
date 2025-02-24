import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { chains } from "../../../utils/chains";
import hre from "hardhat";

const SL1MessageReceiverModule = buildModule("SL1MessageReceiverModule", (m) => {
    // Destination-Chain Wormhole Relayer Address
    // Example: Celo Alfajores
    const network = hre.network.name;
    let chain

    switch (network) {
        case "avalanche":
            chain = chains.find((chain) => chain.name === network);
            break;
        case "avalancheFuji":
        case "hardhat":
            chain = chains.find((chain) => chain.name === "avalancheFuji");
            break;
        case "celoAlfajores":
            chain = chains.find((chain) => chain.name === network);
            break;
        case "celo":
            chain = chains.find((chain) => chain.name === network);
            break;
        case "monadTestnet":
            chain = chains.find((chain) => chain.name === network);
            break;
        default:
            throw new Error(`Network ${network} is not supported`);
    }

    if (!chain) {
        throw new Error(`Chain ${network} is not supported`);
    }

    const whRelayerAddress = chain?.wormholeRelayer

    if (!whRelayerAddress) {
        throw new Error("WH_RELAYER_ADDRESS is required");
    }

    const receiver = m.contract("SL1MessageReceiver", [whRelayerAddress], {});
    return { receiver };
});

export default SL1MessageReceiverModule;