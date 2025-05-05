import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const KOLFactoryTraderJoeModule = buildModule("KOLFactoryTraderJoeModule", (m) => {
    const joeRouter: string = process.env.JOE_ROUTER || "";

    const kolFactory = m.contract("KOLFactoryTraderJoe", [joeRouter], {});
    return { kolFactory };
});

export default KOLFactoryTraderJoeModule;