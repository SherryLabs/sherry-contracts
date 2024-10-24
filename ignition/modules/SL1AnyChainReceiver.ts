import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SL1AnyChainReceiverModule = buildModule("SL1AnyChainReceiverModule", (m) => {

    // Destination-Chain Wormhole Relayer Address
    // Example: Celo Alfajores
    const whRelayerAddress = "0x306B68267Deb7c5DfCDa3619E22E9Ca39C374f84"

    const receiver = m.contract("SL1AnyChainReceiver", [], {});
    return { receiver };
});



export default SL1AnyChainReceiverModule;