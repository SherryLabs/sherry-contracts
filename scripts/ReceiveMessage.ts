const hre = require("hardhat");

async function main() { 
    const receiverContract = await hre.ethers.getContractAt("SL1MessageAnyReceiver", '0x06028Dc2256Cd3b15Be5c600fB3996E59839bE0B');

    const payload = await receiverContract.s_payload();

    if (!payload) {
        console.log("No payload");
        return;
    }

    console.log("Payload : ", payload);

    const decoded = hre.ethers.AbiCoder.defaultAbiCoder().decode(["string", "address"], payload);

    console.log("Decoded : ", decoded);

    const message = await receiverContract.s_lastMessage();
    const lastSender = await receiverContract.s_lastSender();

    console.log("Message : ", message);
    console.log("Last Sender : ", lastSender);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});