import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SherryModule = buildModule("SherryModule", (m) => {
    const sherry = m.contract("Sherry", [], {});
    return { sherry };
}
);

export default SherryModule;