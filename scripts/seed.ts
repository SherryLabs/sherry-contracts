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
    const brandContractAddress = "0x106267b9D291622325D76B64a22aB370E9f1C691";
    const campaignContractAddress = "0x05c9ff225F5F5720D61083F1616dbc8c2E5eADE4";
    const kolContractAddress = "0xB8c3340221c9aE4B3Cad007846b54353c698D339";
    const sherryContractAddress = "0x4E83392C32a616e7393ECf620dc68314637E8C29";

    // Obtener instancias de los contratos
    const brandContract = await hre.ethers.getContractAt("Brand", brandContractAddress);
    const campaignContract = await hre.ethers.getContractAt("Campaign", campaignContractAddress);
    const kolContract = await hre.ethers.getContractAt("KOL", kolContractAddress);
    const sherryContract = await hre.ethers.getContractAt("Sherry", sherryContractAddress);

    const { timestamp } = (await hre.ethers.provider.getBlock('latest'));
    // Sumar 30 días al timestamp
    const thirtyDaysInSeconds = 30 * 24 * 60 * 60 + (timestamp);

    // Crear Nueva Brand
    const nikeBrandTx = await brandContract.createBrand("Adidas", accounts[0])
    nikeBrandTx.wait();
    console.log(`Nike brand tx hash : ${nikeBrandTx.hash}`);

    const adidasBrandTx = await brandContract.createBrand("Adidas", accounts[0])
    adidasBrandTx.wait();
    console.log(`Adidas brand tx hash : ${adidasBrandTx.hash}`);

    const sonyBrandTx = await brandContract.createBrand("SONY", accounts[0])
    sonyBrandTx.wait();
    console.log(`Sony brand tx hash : ${sonyBrandTx.hash}`);

    // Crear una nueva campaña
    const newJordantx = await campaignContract.createCampaign(1, "Nike Jordan", 100, timestamp, thirtyDaysInSeconds);
    await newJordantx.wait();
    console.log(`Nike Jordan campaign tx hash : ${newJordantx.hash}`);
    
    const newMessiTx = await campaignContract.createCampaign(2, "Messi Campaign", 1000, timestamp, thirtyDaysInSeconds);
    await newMessiTx.wait();
    console.log(`Messi campaign tx hash : ${newMessiTx.hash}`);

    const newGalaxyTx = await campaignContract.createCampaign(3, "Galaxy S20", 10000, timestamp, thirtyDaysInSeconds);
    await newGalaxyTx.wait();
    console.log(`Galaxy campaign tx hash : ${newGalaxyTx.hash}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});