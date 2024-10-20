import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CCIPSenderModule = buildModule("CCIPSenderModule", (m) => { 
    // Router address - C-Chain
    const routerAddress = "0xF694E193200268f9a4868e4Aa017A0118C9a8177"
    const linkTokenAddress = "0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846";

    const sender = m.contract("CCIPSenderMiniApp", 
        [routerAddress, linkTokenAddress], 
        {});
    return { sender };
})

export default CCIPSenderModule;