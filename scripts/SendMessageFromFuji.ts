const hre = require("hardhat");

async function main() {
    const accounts = await hre.ethers.getSigners();
    //console.log("Account : ", accounts[0].address);
    
    const senderContract = await hre.ethers.getContractAt("SL1MessageSender", "0x44288B524008c8C6260f7C79A4CA55f44a84cD9c")

    try {
        const targetChain = 44787
        const targetAddress = "0x7d74463Fd71ff65155EAeddb46783Def55D20d97"
        const message = "hola mundo!"

        const tx = await senderContract.sendMessage(
            BigInt(targetChain),
            targetAddress,
            message
        )

        await tx.wait();
        console.log("Transaction sent : ", tx);
    } catch (error) {
        console.log("Error : ", error);
        throw error
    }
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
})