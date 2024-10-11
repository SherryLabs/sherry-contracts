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
    const brandContractAddress = "0x5907d70Dcb0D658801d531F17D3952368f37b182";
    const campaignContractAddress = "0x8Fb01f3d9c4d0639F200E9ae5B1929fe1563c65a";
    const kolContractAddress = "0xfCf749b848f04d28339D4212eb15a757c6d18C8a";
    const sherryContractAddress = "0x9B14d31eAc8Cc7fCb372cEE87de67c8697183a28";

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