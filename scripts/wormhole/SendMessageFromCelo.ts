const hre = require("hardhat");
import * as fs from 'fs';
import path from 'path';

async function main() {
    const senderData = JSON.parse(
        fs.readFileSync(
            path.resolve(__dirname, '../../ignition/deployments/chain-42220/deployed_addresses.json'),
            'utf8'
        )
    );

    const receiverData = JSON.parse(
        fs.readFileSync(
            path.resolve(__dirname, '../../ignition/deployments/chain-43114/deployed_addresses.json'),
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
        const targetChain = 6
        const gasLimit = 100000
        const encodedParams = hre.ethers.AbiCoder.defaultAbiCoder().encode(["string", "address"], ["Hello from Fuji", receiverAddress]);
        const fiveCelo = 10000000000000000

        const txCost = await senderContract.quoteCrossChainCost(targetChain, BigInt(fiveCelo), gasLimit);
        console.log("Cost : ", txCost.toString());


        const encodedFunctionCall = await senderContract.encodeMessage(receiverAddress, encodedParams)

        console.log("Encoded function call : ", encodedFunctionCall);

        const finalAmount = BigInt(fiveCelo) + BigInt(txCost);

        console.log("Five celo : ", fiveCelo.toString());
        console.log("Final amount : ", finalAmount.toString());


        
        const tx = await senderContract.sendMessage(
            targetChain,
            "0x5ee75a1B1648C023e885E58bD3735Ae273f2cc52",
            "0x5ee75a1B1648C023e885E58bD3735Ae273f2cc52",
            "0x",
            gasLimit,
            BigInt(fiveCelo),
            { value: finalAmount }
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



