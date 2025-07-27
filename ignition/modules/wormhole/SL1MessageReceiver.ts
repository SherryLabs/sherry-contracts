import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { getChainByNetwork } from "./utils";

const SL1MessageReceiverModule = buildModule("SL1MessageReceiverModule", (m) => {
    const chain = getChainByNetwork();

    const whRelayerAddress = chain?.wormholeRelayer

    if (!whRelayerAddress) {
        throw new Error("WH_RELAYER_ADDRESS is required");
    }

    const receiver = m.contract("SL1MessageReceiver", [whRelayerAddress], {});
    return { receiver };
});

export default SL1MessageReceiverModule;