const hre = require("hardhat");
const { ethers } = require("ethers");

async function main() {
    const factoryAddress = "0x5fEE6e1B5DDF4CBd7538b975CA48eE0c5d4F1142";
    
    // Define el ABI específico de la función que necesitas
    const factoryABI = [
        "function createMarketAndVestings(tuple(uint8 tokenType, string name, string symbol, address quoteToken, uint256 totalSupply, uint16 creatorShare, uint16 stakingShare, uint256[] bidPrices, uint256[] askPrices, bytes args) marketCreation, tuple(address beneficiary, uint16 sharesBps, uint80 startTime, uint32 cliffDuration, uint32 vestingDuration)[] vestingParams, address recipient, uint256 amountIn, uint256 minAmountOut) payable returns (address)"
    ];

    // Obtener el signer
    const [deployer] = await hre.ethers.getSigners();
    
    // Inicializar el contrato usando el ABI y la dirección
    const factory = new ethers.Contract(
        factoryAddress,
        factoryABI,
        deployer
    );

    try {
        // Parameters for market creation
        const amountIn = hre.ethers.parseEther("2");
        const minAmountOut = 0; // Warning: Don't use 0 in production
        
        const vestingParams = [
            {
                beneficiary: "0x5ee75a1B1648C023e885E58bD3735Ae273f2cc52", // Replace with actual address
                sharesBps: 3000,
                startTime: Math.floor(Date.now() / 1000) + 100,
                cliffDuration: 10 * 24 * 60 * 60, // 10 days in seconds
                vestingDuration: 60 * 24 * 60 * 60 // 60 days in seconds
            },
            {
                beneficiary: "0x5ee75a1B1648C023e885E58bD3735Ae273f2cc52", // Replace with actual address
                sharesBps: 7000,
                startTime: Math.floor(Date.now() / 1000) + 100,
                cliffDuration: 10 * 24 * 60 * 60,
                vestingDuration: 60 * 24 * 60 * 60
            }
        ];

        // Usar parseUnits para manejar números grandes
        const totalSupply = ethers.parseUnits("1", 43); // 1e43 = 1e25 tokens con 18 decimales
        // O alternativamente:
        // const totalSupply = BigInt("1" + "0".repeat(43)); // 1e43
        const creatorShare = 4000;
        const stakingShare = 4000;
        const encodedDecimals = hre.ethers.AbiCoder.defaultAbiCoder().encode(["uint8"], [18]);

        // Define bid prices (ascending order)
        const bidPrices = [
            hre.ethers.parseEther("0.0001"), // 0.0001 ETH
            hre.ethers.parseEther("0.0002"), // 0.0002 ETH
            hre.ethers.parseEther("0.0003"), // 0.0003 ETH
            hre.ethers.parseEther("0.0004"), // 0.0004 ETH
            hre.ethers.parseEther("0.0005")  // 0.0005 ETH
        ];

        // Define ask prices (ascending order)
        const askPrices = [
            hre.ethers.parseEther("0.00015"), // 0.00015 ETH
            hre.ethers.parseEther("0.00025"), // 0.00025 ETH
            hre.ethers.parseEther("0.00035"), // 0.00035 ETH
            hre.ethers.parseEther("0.00045"), // 0.00045 ETH
            hre.ethers.parseEther("0.00055")  // 0.00055 ETH
        ];

        const marketCreation = {
            tokenType: 1,
            name: "Test Token2",
            symbol: "TST2",
            quoteToken: "0xd00ae08403B9bbb9124bB305C09058E32C39A48c", // Replace with actual WNATIVE address
            totalSupply: totalSupply,
            creatorShare: creatorShare,
            stakingShare: stakingShare,
            bidPrices: bidPrices,
            askPrices: askPrices,
            args: encodedDecimals
        };

        const tx = await factory.createMarketAndVestings(
            marketCreation,
            vestingParams,
            deployer.address,
            amountIn,
            minAmountOut,
            { value: amountIn }
        );

        await tx.wait();
        console.log("Market and vestings created. Transaction:", tx.hash);

    } catch (error) {
        console.error("Error:", error);
        throw error;
    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
