import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const KOLRouterFactoryModule = buildModule("KOLRouterFactoryModule", (m) => {
    const joeRouterV1: string = process.env.JOE_ROUTER_V1 || "";
    const joeRouterV2: string = process.env.JOE_ROUTER_V2 || "";
    console.log(joeRouterV1,
        joeRouterV2)

    const kolFactory = m.contract("KOLRouterFactory", [
        joeRouterV1,
        joeRouterV2
    ], {});
    return { kolFactory };
});

export default KOLRouterFactoryModule;