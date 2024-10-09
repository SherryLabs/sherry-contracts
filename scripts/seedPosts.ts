const hre = require("hardhat");

async function main() {
    /**
     * @Note Run seed in local network
     * @Command npx hardhat run scripts/seed.ts
     * @Note Run seed in base sepolia network
     * @Command npx hardhat run scripts/seed.ts --network baseSepolia
     * */
    const accounts = await hre.ethers.getSigners();

    // Direcciones de los contratos desplegados
    const brandContractAddress = "0x657E6d2274eD0952C8F8Ed58F16756d99A823Bd8";
    const campaignContractAddress = "0x71AA6213cea1fFfc38576f262acDC2666BdC7e98";
    const kolContractAddress = "0x766485E35331c92784F257dB68EEA899930C6DAB";
    const sherryContractAddress = "0x727E61467e0A5A72E2234fe0dEDc09526884b14d";

    // Obtener instancias de los contratos
    const brandContract = await hre.ethers.getContractAt("Brand", brandContractAddress);
    const campaignContract = await hre.ethers.getContractAt("Campaign", campaignContractAddress);
    const kolContract = await hre.ethers.getContractAt("KOL", kolContractAddress);
    const sherryContract = await hre.ethers.getContractAt("Sherry", sherryContractAddress);

    const tx1 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx1.wait();
    console.log(`TX1 HASH : `, tx1.hash)
    const tx2 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx2.wait();
    console.log(`TX2 HASH : `, tx2.hash)
    const tx3 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx3.wait();
    console.log(`TX3 HASH : `, tx3.hash)

    const tx4 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx4.wait();
    console.log(`TX4 HASH : `, tx4.hash)

    const tx5 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
    tx5.wait();
    console.log(`TX5 HASH : `, tx5.hash)

    const tx6 = await sherryContract.createPost(1, "https://ipfs.io/ipfs/bafkreibmtmc76422p3zidu4pze5obejaemaes2sy5kshysw6x6rjb4nfl4");
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
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});