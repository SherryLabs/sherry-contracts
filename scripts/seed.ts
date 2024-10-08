const hre = require("hardhat");

async function main() {

    const accounts = await hre.ethers.getSigners();

    /*
    for (const account of accounts) {
        console.log(account.address);
    }
    */

    // Direcciones de los contratos desplegados
    const brandContractAddress = "0x45f92b64944A2ADCDaE9A4F09C3A5EA4a8FE5525";
    const campaignContractAddress = "0xce9D74DDBB13CAB9FB5019E9C859f20f4bcE3723";
    const kolContractAddress = "0xd6b8f5Ddf0dA19C4bEF691A93666605A451A39Cc";
    const sherryContractAddress = "0xe0e07c70b7fB31d58AFf69C1750520baebaa632D";

    // Obtener instancias de los contratos
    const brandContract = await hre.ethers.getContractAt("Brand", brandContractAddress);
    const campaignContract = await hre.ethers.getContractAt("Campaign", campaignContractAddress);
    const kolContract = await hre.ethers.getContractAt("KOL", kolContractAddress);
    const sherryContract = await hre.ethers.getContractAt("Sherry", sherryContractAddress);

    const { timestamp } = (await hre.ethers.provider.getBlock('latest'));
    // Sumar 30 días al timestamp
    const thirtyDaysInSeconds = 30 * 24 * 60 * 60 + (timestamp);

    // Crear Nueva Brand
    const adidasBrandTx = await brandContract.createBrand("Adidas", accounts[0])
    adidasBrandTx.wait();
    console.log(`${adidasBrandTx.hash}`);

    const sonyBrandTx = await brandContract.createBrand("SONY", accounts[0])
    sonyBrandTx.wait();
    console.log(`${sonyBrandTx.hash}`);

    // Crear una nueva campaña
    const newJordantx = await campaignContract.createCampaign(1, "Nike Jordan", 100, timestamp, thirtyDaysInSeconds);
    await newJordantx.wait();

    const newMessiTx = await campaignContract.createCampaign(2, "Messi Campaign", 1000, timestamp, thirtyDaysInSeconds);
    await newMessiTx.wait();

    const newGalaxyTx = await campaignContract.createCampaign(3, "Galaxy S20", 10000, timestamp, thirtyDaysInSeconds);
    await newGalaxyTx.wait();
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});