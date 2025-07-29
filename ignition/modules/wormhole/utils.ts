import { chains } from "../../../utils/chains";
import hre from "hardhat";

export function getChainByNetwork() {
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
            break;
        case "base":
            chain = chains.find((chain) => chain.name === network);
            break;
        case "baseSepolia":
            chain = chains.find((chain) => chain.name === "baseSepolia");
            break;
        case "sepolia":
            chain = chains.find((chain) => chain.name === network);
            break;
        case "mainnet":
            chain = chains.find((chain) => chain.name === network);
            break;
        default:
            throw new Error(`Network ${network} is not supported`);
    }

    if (!chain) {
        throw new Error(`Chain ${network} is not supported`);
    }

    return chain;
}