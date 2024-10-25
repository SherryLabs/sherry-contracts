const hre = require("hardhat");

async function main() {
    const accounts = await hre.ethers.getSigners();

    const receiver = await hre.ethers.getContractAt("SL1MessageAnyReceiver", "0x4f34C7119c1C918c606792D8a481D915D845DD2E");

    const sourceChainId = 6; // Avalanche Fuji
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
