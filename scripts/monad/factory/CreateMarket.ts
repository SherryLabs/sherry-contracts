import { parseAbi, encodeAbiParameters } from 'viem';
import hre from 'hardhat';

const TMFactoryAddress = '0x501ee2D4AA611C906F785e10cC868e145183FCE4' // 🌉 Monad Testnet
const WMONAD = "0x760AfE86e5de5fa0Ee542fc7B7B713e1c5425701"

const abi = parseAbi([
    'function createMarketAndToken((uint96 tokenType, string name, string symbol, address quoteToken, uint256 totalSupply, uint16 creatorShare, uint16 stakingShare, uint256[] bidPrices, uint256[] askPrices, bytes args) parameters) external returns (address baseToken, address market)'
]);

async function main() {
    try {
        const [walletClient] = await hre.viem.getWalletClients();
        const publicClient = await hre.viem.getPublicClient();

        const parameters = {
            tokenType: 1n, // 🔢 BigInt because it's a uint96
            name: 'Sherry v1',
            symbol: 'SHERRY',
            quoteToken: WMONAD as `0x${string}`, // 💱 Quote token address (WMONAD)
            totalSupply: 10000000000000000000000000n, // 💰 1e25 in BigInt
            creatorShare: 4000, // 💸 40% in BPS (4000 / 10000 = 40%)
            stakingShare: 4000, // 📈 40% in BPS (4000 / 10000 = 40%)
            bidPrices: [0n, 9800000000000000n, 9900000000000000n], // 🛒 Initial bid prices (BigInt)
            askPrices: [0n, 9900000000000000n, 10000000000000000n], // 🏷️ Initial ask prices (BigInt)
            args: encodeAbiParameters([{ type: 'uint256' }], [18n]), // 🔢 Encoded token decimals
        };

        if (parameters.bidPrices.length !== parameters.askPrices.length || parameters.bidPrices.length < 2 || parameters.bidPrices.length > 101) {
            throw new Error('Price arrays have invalid length.');
        }

        console.log('🚀 Simulating createMarketAndToken to get return values...');

        // First simulate the contract call to get the return values
        const { result, request } = await publicClient.simulateContract({
            address: TMFactoryAddress,
            abi,
            functionName: 'createMarketAndToken',
            args: [parameters],
            account: walletClient.account,
        });

        // Extract the return values from the simulation
        const baseToken = result[0];
        const market = result[1];
        
        console.log('⏳ Expected Token Address:', baseToken);
        console.log('⏳ Expected Market Address:', market);

        console.log('🚀 Executing actual transaction...');
        
        // Execute the actual transaction
        const tx = await walletClient.writeContract(request);
        
        console.log('📤 Transaction sent:', tx);
        const receipt = await publicClient.waitForTransactionReceipt({ hash: tx });
        console.log('✅ Transaction confirmed:', receipt);

        console.log('🪙 Created Token Address:', baseToken);
        console.log('🏛️ Created Market Address:', market);
        
        return { tx, baseToken, market };
    } catch (error: any) {
        if (error.cause) {
            console.error('❌ Error details:', error.cause);
        }
        console.error('🚨 Error executing transaction:', error.message || error);
    }
}

main()
    .then((result) => {
        if (result) {
            console.log('✨ Script completed successfully');
        }
    })
    .catch((error) => {
        console.error('💥 Script error:', error);
    });
