const hre = require("hardhat");

async function main() {
    const accounts = await hre.ethers.getSigners();

    const senderContract = await hre.ethers.getContractAt("SL1Sender", '0x76ceB8017741c7fEAcae7D1179b0d3eB4151dcc4');

    /*
    function sendMessage(
        address _destinationContract,
        bytes calldata _encodedFunctionCall,
        address _destinationAdress,
        bytes32 _destinationChain,
        uint256 _gasLimit
    ) public { }
    */

    try {
        const tx = await senderContract.sendMessage(
            '0x043135e9dF9f74B9C4580273C418B44fA8896726', 
            '0xa4136862000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000013100000000000000000000000000000000000000000000000000000000000000',
            '0x06028Dc2256Cd3b15Be5c600fB3996E59839bE0B',
            '0x7fc93d85c6d62c5b2ac0b519c87010ea5294012d1e407030d6acd0021cac10d5',
            BigInt(200000)
        );
    
        await tx.wait();

        console.log("Transaction sent : ", tx);
    } catch (error) {
        console.log("Error : ", error);
        
    }

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});