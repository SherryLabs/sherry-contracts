const hre = require("hardhat");
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

    if (!senderAddress || !receiverAddress) {
        throw new Error("Sender and Receiver Address is required");
    }

    const senderContract = await hre.ethers.getContractAt("SL1MessageSender",
        senderAddress)

    try {
        const targetChain = 14
        const gasLimit = 800000
        const encodedParams = hre.ethers.AbiCoder.defaultAbiCoder().encode(["string", "address"], ["Hello from Fuji", receiverAddress]);

        const value = await senderContract.quoteCrossChainCost(targetChain, gasLimit);
        console.log("Cost : ", value.toString());

        const encodedFunctionCall = await senderContract.encodeMessage(receiverAddress, encodedParams)

        console.log("Encoded function call : ", encodedFunctionCall);

        // Uncomment the below code to send the message

        const tx = await senderContract.sendMessage(
            targetChain,
            receiverAddress,
            receiverAddress,
            encodedParams,
            gasLimit,
            { value: value }
        )

        await tx.wait();
        console.log("Transaction sent : ", tx.hash)


    } catch (error) {
        console.log("Error : ", error);
        throw error
    }
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
})