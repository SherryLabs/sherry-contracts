const hre = require("hardhat");
import { chains } from "../utils/chains";
import * as fs from 'fs';

async function main() {
    const receiverAddress = JSON.parse(fs.readFileSync("../ignition/deployments/chain-43113/deployed_addresses.json").toString()).address;

    console.log("Receiver Address : ", receiverAddress);

    if(!receiverAddress) { 
        throw new Error("Receiver Address is required");
    }

    const receiver = await hre.ethers.getContractAt("SL1MessageReceiver", "0x4f34C7119c1C918c606792D8a481D915D845DD2E");

    const fujiChain = chains.find((chain) => chain.name === "avalancheFuji");

    const sourceChainId = fujiChain?.chainId;
    const senderAddress = "0x502885C7765B01232df8aE985A265E3FBe8e742A" // Sender Address Fuji
    const senderFormattedAddress = hre.ethers.zeroPadValue(senderAddress, 32);

    console.log("sender address : ", senderAddress)
    console.log("Sender formatted address : ", senderFormattedAddress);


    const tx = await receiver.setRegisteredSender(
        sourceChainId,
        senderFormattedAddress
    )

    await tx.wait();
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
