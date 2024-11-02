const hre = require("hardhat");
import { chains } from "../../utils/chains";
import * as fs from 'fs';
import path from 'path';

async function main() {
    const senderData = JSON.parse(
        fs.readFileSync(
            path.resolve(__dirname, '../ignition/deployments/chain-43113/deployed_addresses.json'),
            'utf8'
        )
    );

    const receiverData = JSON.parse(
        fs.readFileSync(
            path.resolve(__dirname, '../ignition/deployments/chain-44787/deployed_addresses.json'),
            'utf8'
        )
    );

    if (!senderData || !receiverData) {
        throw new Error("Sender and Receiver Data is required");
    }

    const senderAddress = senderData["SL1MessageSenderModule#SL1MessageSender"]
    const receiverAddress = receiverData["SL1MessageReceiverModule#SL1MessageReceiver"]
    const receiver = await hre.ethers.getContractAt("SL1MessageReceiver", receiverAddress);

    const fujiChain = chains.find((chain) => chain.name === "avalancheFuji");

    const sourceChainId = fujiChain?.chainId;
    
    const senderFormattedAddress = hre.ethers.zeroPadValue(senderAddress, 32);

    console.log("sender address : ", senderAddress)
    console.log("Sender formatted address : ", senderFormattedAddress);


    const tx = await receiver.setRegisteredSender(
        sourceChainId,
        senderFormattedAddress
    )

    await tx.wait();

    console.log("Sender registered in receiver contract : ", tx.hash);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
