const hre = require("hardhat");

async function main() {
    /**
     * @Note Run seed in local network
     * @Command npx hardhat run scripts/seed.ts
     * @Note Run seed in base sepolia network
     * @Command npx hardhat run scripts/seed.ts --network baseSepolia
     * */

    // Direcciones de los contratos desplegados
    const brandContractAddress = "0x61f1A83641BE8D38B64d6Dd8A9Ce27A790910AdB";
    const campaignContractAddress = "0xAF8f574dFa31eAf30471C89b46e6a64993FAb5eF";
    const kolContractAddress = "0xfECf01499487A8A4eC2A1fc5c0e7870ab09DE579";
    const sherryContractAddress = "0xBcf74ca91C7af172ed1A2c973108C6bC086B4d63";
    // Obtener instancias de los contratos
    const brandContract = await hre.ethers.getContractAt("Brand", brandContractAddress);
    const campaignContract = await hre.ethers.getContractAt("Campaign", campaignContractAddress);
    const kolContract = await hre.ethers.getContractAt("KOL", kolContractAddress);
    const sherryContract = await hre.ethers.getContractAt("Sherry", sherryContractAddress);

    const tx1 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreid2lcublbqwekeerawqa5llh5jnthq4u34q4kdya5wdeo6a6ycohy");
    tx1.wait();
    console.log(`TX1 HASH : `, tx1.hash)
    const tx2 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreihek5udso3upicyilyk3cq4e4ublthbktutcmswcuy2qrbjskk35y");
    tx2.wait();
    console.log(`TX2 HASH : `, tx2.hash)
    /*
    const tx3 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx3.wait();
    console.log(`TX3 HASH : `, tx3.hash)

    const tx4 = await sherryContract.createPost(2, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx4.wait();
    console.log(`TX4 HASH : `, tx4.hash)

    const tx5 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx5.wait();
    console.log(`TX5 HASH : `, tx5.hash)

    const tx6 = await sherryContract.createPost(2, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx6.wait();
    console.log(`TX6 HASH : `, tx6.hash)

    const tx7 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx7.wait();
    console.log(`TX7 HASH : `, tx7.hash)

    const tx8 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx8.wait();
    console.log(`TX8 HASH : `, tx8.hash)

    const tx9 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx9.wait();
    console.log(`TX9 HASH : `, tx9.hash)
    */
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});