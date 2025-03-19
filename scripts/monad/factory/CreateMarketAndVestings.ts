import { parseAbi, encodeAbiParameters } from 'viem';
import hre from 'hardhat';
import dotenv from 'dotenv';

dotenv.config();

//const TMFactoryAddress = '0x86B19AE67DD6EAcA8df0302Da7711e4Cc031F6B2'; // AVAX FUJI
//const TMFactoryAddress = '0xbaA2D7D2c903AfDcA72Ce8Ead3D99071964364E5'// Avax Mainnet
const TMFactoryAddress = '0x501ee2D4AA611C906F785e10cC868e145183FCE4' // Monad Testnet
const WMONAD = "0x760AfE86e5de5fa0Ee542fc7B7B713e1c5425701"
//const PRIVATE_KEY = process.env.DEPLOYER_KEY as string;
//const RPC_URL = 'http://127.0.0.1:8545'; // Asegúrate de que Hardhat esté corriendo

const abi = parseAbi([
    'function createMarketAndVestings((uint96 tokenType, string name, string symbol, address quoteToken, uint256 totalSupply, uint16 creatorShare, uint16 stakingShare, uint256[] bidPrices, uint256[] askPrices, bytes args) parameters, (address beneficiary, uint16 bps, uint80 startTimestamp, uint32 cliffDuration, uint32 vestingDuration)[] vestingParams, address initialBuyer, uint256 amountIn, uint256 minAmountOut) external returns (address baseToken, address market)'
]);

async function main() {
    try {
        const [walletClient] = await hre.viem.getWalletClients();
        const publicClient = await hre.viem.getPublicClient();

        // Define user addresses for vestings
        const user1 = "0x5ee75a1B1648C023e885E58bD3735Ae273f2cc52" as `0x${string}`;
        const user2 = "0x5ee75a1B1648C023e885E58bD3735Ae273f2cc52" as `0x${string}`;
        
        // Market creation parameters
        const marketCreationParams = {
            tokenType: 1n, // BigInt porque es un uint96
            name: 'Test Token2',
            symbol: 'TST2',
            quoteToken: WMONAD as `0x${string}`,
            totalSupply: 10000000000000000000000000n, // 1e25 in BigInt
            creatorShare: 4000, // 40% in BPS (4000 / 10000 = 40%)
            stakingShare: 4000, // 40% in BPS (4000 / 10000 = 40%)
            bidPrices: [0n, 9800000000000000n, 9900000000000000n], // Initial bid prices (BigInt)
            askPrices: [0n, 9900000000000000n, 10000000000000000n], // Initial ask prices (BigInt)
            args: encodeAbiParameters([{ type: 'uint256' }], [18n]), // Encoded token decimals
        };

        // Vesting parameters - fixed structure to match contract expectations
        const currentTimestamp = BigInt(Math.floor(Date.now() / 1000));
        const vestingParams = [
            {
                beneficiary: user1 as `0x${string}`,
                bps: 3000,
                startTimestamp: currentTimestamp + 100n,  // Using BigInt for timestamp
                cliffDuration: 10 * 86400,              // 10 days in seconds
                vestingDuration: 60 * 86400,            // 60 days in seconds
            },
            {
                beneficiary: user2 as `0x${string}`,
                bps: 7000,
                startTimestamp: currentTimestamp + 100n,
                cliffDuration: 10 * 86400,
                vestingDuration: 60 * 86400,
            }
        ];

        // Transaction parameters
        const amountIn = 2000000000000000000n; // 2 ether in wei
        const minAmountOut = 0n; // do not use 0 in production environment

        const tx = await walletClient.writeContract({
            address: TMFactoryAddress,
            abi,
            functionName: 'createMarketAndVestings',
            args: [
                marketCreationParams,
                vestingParams,
                user1,
                amountIn,
                minAmountOut
            ],
        });

        console.log('Transaction sent:', tx);
        const receipt = await publicClient.waitForTransactionReceipt({ hash: tx });
        console.log('Transaction confirmed:', receipt);
    } catch (error: any) {
        if (error.cause) {
            console.error('Error details:', error.cause);
        }
        console.error('Error executing transaction:', error.message || error);
    }
}

main().catch((error) => {
    console.error('Script error:', error);
});
