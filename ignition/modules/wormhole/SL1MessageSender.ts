import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { chains } from "../../../utils/chains";
import hre from "hardhat";

const SL1MessageSenderModule = buildModule("SL1MessageSenderModule", (m) => {

    const network = hre.network.name;
    let chain;

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
            break
        case "monadTestnet":
            chain = chains.find((chain) => chain.name === network);
            break;
        default:
            throw new Error(`Network ${network} is not supported`);
    }

    if (!chain) {
        throw new Error(`Chain ${network} is not supported`);
    }
    // Origin-Chain Wormhole Relayer Address
    const whRelayerAddress = chain.wormholeRelayer;
    const whChainId = chain.chainIdWh;

    if (!whRelayerAddress) {
        throw new Error("WH_RELAYER_ADDRESS is required");
    }

    // Deploy SL1MessageSender contract in Fuji
    const sender = m.contract("SL1MessageSender", [whRelayerAddress, whChainId], {});
    return { sender };
});

export default SL1MessageSenderModule;