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
    const brandContractAddress = "0xD9aEE67370E158faC0904C6e9F0bb3D967C135C4";
    const campaignContractAddress = "0xc9188127359280EF92C643701c3E30DFd2aa1dE0";
    const kolContractAddress = "0xa381f12C079ed5382D1630C1467d32bd821501f5";
    const sherryContractAddress = "0xBf0984EFd4e04540b1814cdf3FC890728fEC4652";

    // Obtener instancias de los contratos
    const brandContract = await hre.ethers.getContractAt("Brand", brandContractAddress);
    const campaignContract = await hre.ethers.getContractAt("Campaign", campaignContractAddress);
    const kolContract = await hre.ethers.getContractAt("KOL", kolContractAddress);
    const sherryContract = await hre.ethers.getContractAt("Sherry", sherryContractAddress);

    const { timestamp } = (await hre.ethers.provider.getBlock('latest'));
    // Sumar 30 días al timestamp
    const thirtyDaysInSeconds = 30 * 24 * 60 * 60 + (timestamp);

    // Crear Nueva Brand
    const adidasTx = await brandContract.createBrand("Adidas", accounts[0])
    adidasTx.wait();
    console.log(`Adidas brand tx hash : ${adidasTx.hash}`);

    const baseTx = await brandContract.createBrand("Base", accounts[0])
    baseTx.wait();
    console.log(`Base brand tx hash : ${baseTx.hash}`);

    const zaraTx = await brandContract.createBrand("Zara", accounts[0])
    zaraTx.wait();
    console.log(`Zara brand tx hash : ${zaraTx.hash}`);

    const nikeTx = await brandContract.createBrand("Nike", accounts[0])
    nikeTx.wait();
    console.log(`Nike brand tx hash : ${nikeTx.hash}`);

    // Crear una nueva campaña
    const adidasUri= "https://ipfs.io/ipfs/QmbuLMFweibrZRbyJtFcCnf8oUEkgXfxHdQPamemkZc4uR/1.json"
    const baseUri = "https://ipfs.io/ipfs/QmbuLMFweibrZRbyJtFcCnf8oUEkgXfxHdQPamemkZc4uR/3.json"
    const zaraUri = "https://ipfs.io/ipfs/QmbuLMFweibrZRbyJtFcCnf8oUEkgXfxHdQPamemkZc4uR/2.json"
    const nikeUri = "https://ipfs.io/ipfs/QmbuLMFweibrZRbyJtFcCnf8oUEkgXfxHdQPamemkZc4uR/4.json"

    const adidasCampaignTx = await campaignContract.createCampaign(1, "Adidas Originals", 100, timestamp, thirtyDaysInSeconds, adidasUri);
    await adidasCampaignTx.wait();
    console.log(`Nike Jordan campaign tx hash : ${adidasCampaignTx.hash}`);
    
    const baseCampaignTx = await campaignContract.createCampaign(2, "Base Summer Hackathon", 1000, timestamp, thirtyDaysInSeconds, baseUri);
    await baseCampaignTx.wait();
    console.log(`Messi campaign tx hash : ${baseCampaignTx.hash}`);

    const zaraCampaignTx = await campaignContract.createCampaign(3, "Zara Spring Collection", 10000, timestamp, thirtyDaysInSeconds, zaraUri);
    await zaraCampaignTx.wait();
    console.log(`Galaxy campaign tx hash : ${zaraCampaignTx.hash}`);

    const nikeCampaignTx = await campaignContract.createCampaign(4, "Nike Jordan 90's", 10000, timestamp, thirtyDaysInSeconds, nikeUri);
    await nikeCampaignTx.wait();
    console.log(`Galaxy campaign tx hash : ${nikeCampaignTx.hash}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});