import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { getChainByNetwork } from "./utils";

const SL1MessageSenderModule = buildModule("SL1MessageSenderModule", (m) => {

    const chain = getChainByNetwork();
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