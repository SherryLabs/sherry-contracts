import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CheckSenderModule = buildModule("CheckSenderModule", (m) => {
    const checkSender = m.contract("CheckSender", [], { });

    return { checkSender };
 })

 export default CheckSenderModule;