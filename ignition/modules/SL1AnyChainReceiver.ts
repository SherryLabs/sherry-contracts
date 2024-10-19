import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SL1AnyChainReceiverModule = buildModule("SL1AnyChainReceiverModule", (m) => {
    const receiver = m.contract("SL1AnyChainReceiver", [], {});
    return { receiver };

});

export default SL1AnyChainReceiverModule;