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