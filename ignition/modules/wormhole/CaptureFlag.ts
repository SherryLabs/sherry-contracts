import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CaptureFlagModule = buildModule("CaptureFlagModule", (m) => {
    const captureFlag = m.contract("CaptureFlagWH", [], {});
    return { captureFlag };
});

export default CaptureFlagModule;