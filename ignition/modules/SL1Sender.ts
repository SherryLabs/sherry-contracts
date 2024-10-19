import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SL1SenderModule = buildModule("SL1SenderModule", (m) => {
    const sender = m.contract("SL1Sender", [], {});
    return { sender };
});

export default SL1SenderModule;