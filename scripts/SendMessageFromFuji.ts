const hre = require("hardhat");

async function main() {
    const accounts = await hre.ethers.getSigners();
    //console.log("Account : ", accounts[0].address);

    const senderContract = await hre.ethers.getContractAt("SL1MessageSender",
        "0x502885C7765B01232df8aE985A265E3FBe8e742A")

    try {
        const targetChain = 14
        const targetAddress = "0x06028Dc2256Cd3b15Be5c600fB3996E59839bE0B"
        const message = "probando sender!"

        const value = await senderContract.quoteCrossChainCost(targetChain);
        console.log("Cost : ", value.toString());

        
        const tx = await senderContract.sendMessage(
            targetChain,
            targetAddress,
            message,
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