import { parseAbi, encodeAbiParameters } from 'viem';
import { hardhat } from 'viem/chains';
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
    'function createMarketAndToken((uint96 tokenType, string name, string symbol, address quoteToken, uint256 totalSupply, uint16 creatorShare, uint16 stakingShare, uint256[] bidPrices, uint256[] askPrices, bytes args) parameters) external returns (address baseToken, address market)'
]);

async function main() {
    try {

        const [walletClient] = await hre.viem.getWalletClients();
        const publicClient = await hre.viem.getPublicClient();

        const parameters = {
            tokenType: 1n, // BigInt porque es un uint96
            name: 'MyToken',
            symbol: 'MTK',
            quoteToken: WMONAD as `0x${string}`, // Dirección del token de cotización (WMONAD)
            totalSupply: 10000000000000000000000000n, // 1e25 en BigInt
            creatorShare: 4000, // 40% en BPS (4000 / 10000 = 40%)
            stakingShare: 4000, // 40% en BPS (4000 / 10000 = 40%)
            bidPrices: [0n, 9800000000000000n, 9900000000000000n], // Precios de oferta iniciales (BigInt)
            askPrices: [0n, 9900000000000000n, 10000000000000000n], // Precios de venta iniciales (BigInt)
            args: encodeAbiParameters([{ type: 'uint256' }], [18n]), // Decimales del token codificados
        };

        if (parameters.bidPrices.length !== parameters.askPrices.length || parameters.bidPrices.length < 2 || parameters.bidPrices.length > 101) {
            throw new Error('Los arrays de precios tienen una longitud inválida.');
        }

        console.log('Ejecutando createMarketAndToken...');

        const tx = await walletClient.writeContract({
            address: TMFactoryAddress,
            abi,
            functionName: 'createMarketAndToken',
            args: [parameters],
        });

        console.log('Transacción enviada:', tx);
        const receipt = await publicClient.waitForTransactionReceipt({ hash: tx });
        console.log('Transacción confirmada:', receipt);
    } catch (error: any) {
        if (error.cause) {
            console.error('Detalles del error:', error.cause);
        }
        console.error('Error al ejecutar la transacción:', error.message || error);
    }
}

main().catch((error) => {
    console.error('Error en el script:', error);
});
