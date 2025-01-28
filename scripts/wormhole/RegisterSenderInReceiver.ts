const hre = require("hardhat");
import { chains } from "../../utils/chains";
import * as fs from 'fs';
import path from 'path';

async function main() {
    const receiverName = hre.network.name;
    let chainSender;

    const chainReceiver = chains.find((chain) => chain.name === receiverName);

    if (!chainReceiver) throw new Error("Chain ID is required");

    if (chainReceiver.chainId === 43114) chainSender = 42220; // avalanche -> celo
    else if (chainReceiver.chainId === 42220) chainSender = 43114; // celo -> avalanche
    else if (chainReceiver.chainId === 44787) chainSender = 43113; // alfajores -> fuji
    else if (chainReceiver.chainId === 43113) chainSender = 44787; // fuji -> alfajores
    else throw new Error(`Chain ID ${chainReceiver} for ${hre.network.name} is not supported`);

    const senderData = JSON.parse(
        fs.readFileSync(
            path.resolve(__dirname, `../../ignition/deployments/chain-${chainSender}/deployed_addresses.json`),
            'utf8'
        )
    );

    const receiverData = JSON.parse(
        fs.readFileSync(
            path.resolve(__dirname, `../../ignition/deployments/chain-${chainReceiver.chainId}/deployed_addresses.json`),
            'utf8'
        )
    );

    if (!senderData || !receiverData) {
        throw new Error("Sender and Receiver Data is required");
    }

    const senderAddress = senderData["SL1MessageSenderModule#SL1MessageSender"]
    const receiverAddress = receiverData["SL1MessageReceiverModule#SL1MessageReceiver"]
    const receiver = await hre.ethers.getContractAt("SL1MessageReceiver", receiverAddress);

    const sourceChain = chains.find((chain) => chain.chainId === chainSender);
    const senderFormattedAddress = hre.ethers.zeroPadValue(senderAddress, 32);

    const tx = await receiver.setRegisteredSender(
        sourceChain?.chainIdWh,
        senderFormattedAddress
    )

    await tx.wait();

    console.log("Sender registered in receiver contract : ", tx.hash);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
