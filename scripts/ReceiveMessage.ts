const hre = require("hardhat");
import * as fs from 'fs';
import path from 'path';

async function main() {

    const receiverData = JSON.parse(
        fs.readFileSync(
            path.resolve(__dirname, '../ignition/deployments/chain-44787/deployed_addresses.json'),
            'utf8'
        )
    );

    if (!receiverData) {
        throw new Error("Receiver Address is required");
    }

    const receiverAddress = receiverData["SL1MessageReceiverModule#SL1MessageReceiver"]

    if (!receiverAddress) {
        throw new Error("Receiver Address is required");
    }

    const receiverContract = await hre.ethers.getContractAt("SL1MessageReceiver", receiverAddress);
    //const payloadOrigin = hre.ethers.AbiCoder.defaultAbiCoder().encode(["string", "address"], ["Hello from Fuji", receiverAddress]);

    //console.log("Payload Origin : ", payloadOrigin);

    /*
    const receiveMsg = await receiverContract.receiveWormholeMessages(
        payloadOrigin,
        [],
        '0x00000000000000000000000060a86b97a7596ebfd25fb769053894ed0d9a8366',
        5,
        payloadOrigin
    )

    await receiveMsg.wait();
    
    console.log("Message Received " , receiveMsg.hash);
    */

    const payload = await receiverContract.s_payload();

    if (!payload) {
        throw new Error("Message has not been received yet");
    }

    //const decoded = hre.ethers.AbiCoder.defaultAbiCoder().decode(["string", "address"], payload);

    //console.log("Decoded : ", decoded);

    const lastPayload = await receiverContract.s_payload();
    const lastSender = await receiverContract.s_lastSender();
    const  lastEncoded =  await receiverContract.s_lastEncodedFunctionCall()
    const lastContractToBeCalled = await  receiverContract.s_lastContractToBeCalled()

    console.log("Last payload : ", lastPayload);
    console.log("Last Sender : ", lastSender);
    console.log("Last Encoded function call : ", lastEncoded);
    console.log("Last Contract to be called : ", lastContractToBeCalled);
    
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});