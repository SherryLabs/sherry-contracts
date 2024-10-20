const hre = require("hardhat");

async function main() {
    const accounts = await hre.ethers.getSigners();

    const senderContract = await hre.ethers.getContractAt("SL1Sender", '0x76ceB8017741c7fEAcae7D1179b0d3eB4151dcc4');

    const tx = await senderContract.sendMessage(
        '0x2f4462dab28A090B4BEF9906CCd6bBd803D3E21c',
        '0xa4136862000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000013100000000000000000000000000000000000000000000000000000000000000',
        '0x76ceB8017741c7fEAcae7D1179b0d3eB4151dcc4',
        '0xdb76a6c20fd0af4851417c79c479ebb1e91b3d4e7e57116036d203e3692a0856',
        BigInt(200000)
    );

    await tx.wait();

    console.log("Transaction sent : ", tx);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});