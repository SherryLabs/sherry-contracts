import { parseEther, formatEther, parseAbi, encodeAbiParameters } from "viem";
import hre from "hardhat";

const factoryAbi = parseAbi([
    'function createMarketAndToken((uint8 tokenType, string name, string symbol, address quoteToken, uint256 totalSupply, uint16 creatorShare, uint16 stakingShare, uint256[] bidPrices, uint256[] askPrices, bytes args)) returns (address token, address market)'
]);

type MarketCreation = {
    tokenType: bigint;
    name: string;
    symbol: string;
    quoteToken: `0x${string}`;
    totalSupply: bigint;
    creatorShare: bigint;
    stakingShare: bigint;
    bidPrices: bigint[];
    askPrices: bigint[];
    args: `0x${string}`;
};

async function main() {
    const factoryAddress = "0x5fEE6e1B5DDF4CBd7538b975CA48eE0c5d4F1142";

    const [walletClient] = await hre.viem.getWalletClients();
    const publicClient = await hre.viem.getPublicClient();

    // Check balance
    const balance = await publicClient.getBalance({
        address: walletClient.account.address,
    });

    console.log(
        `Balance of ${walletClient.account.address}: ${formatEther(balance)} AVAX`
    );

    try {
        // Match exactly the Solidity values
        const bidPrices = [
            0n,
            BigInt("1000000000000000000") // 100e14 = 0.01 ETH
        ];

        const askPrices = [
            0n,
            BigInt("990000000000000000") // 99e14 = 0.0099 ETH
        ];

        // Encode decimals exactly as Solidity's abi.encode(18)
        const encodedDecimals = "0x0000000000000000000000000000000000000000000000000000000000000012";

        const marketCreation = {
            tokenType: Number(1n), // Convert bigint to number
            name: "Test Token2",
            symbol: "TST2",
            quoteToken: "0xd00ae08403B9bbb9124bB305C09058E32C39A48c" as `0x${string}`, // WETH
            totalSupply: BigInt("10000000000000000000000000"), // 1e25
            creatorShare: Number(4000n), // Convert bigint to number
            stakingShare: Number(4000n), // Convert bigint to number
            bidPrices: [
                0n,
                BigInt("1000000000000000000") // 100e14 = 0.01 ETH
            ],
            askPrices: [
                0n,
                BigInt("990000000000000000") // 99e14 = 0.0099 ETH
            ],
            args: encodedDecimals as `0x${string}` // Use the raw hex string that matches Solidity's abi.encode
        };

        // Manually encode the MarketCreation struct using encodeAbiParameters
        const encodedMarketCreation = encodeAbiParameters(
            [
                { type: 'uint8' },
                { type: 'string' },
                { type: 'string' },
                { type: 'address' },
                { type: 'uint256' },
                { type: 'uint16' },
                { type: 'uint16' },
                { type: 'uint256[]' },
                { type: 'uint256[]' },
                { type: 'bytes' }
            ],
            [
                marketCreation.tokenType,
                marketCreation.name,
                marketCreation.symbol,
                marketCreation.quoteToken,
                marketCreation.totalSupply,
                marketCreation.creatorShare,
                marketCreation.stakingShare,
                marketCreation.bidPrices,
                marketCreation.askPrices,
                marketCreation.args
            ]
        );

        // Estimate gas
        console.log("Estimating gas...");
        const gasEstimate = await publicClient.estimateContractGas({
            address: factoryAddress,
            abi: factoryAbi,
            functionName: "createMarketAndToken",
            args: [marketCreation], // Pass the encoded data
            account: walletClient.account.address,
        });

        console.log("Estimated gas:", gasEstimate.toString());

        // Send transaction
        console.log("Sending transaction...");
        const hash = await walletClient.writeContract({
            address: factoryAddress,
            abi: factoryAbi,
            functionName: "createMarketAndToken",
            args: [marketCreation], // Pass the encoded data
            gas: (gasEstimate * 120n) / 100n, // 20% buffer
        });

        console.log("Transaction sent:", hash);

        // Wait for receipt
        const receipt = await publicClient.waitForTransactionReceipt({ hash });
        console.log("Transaction mined:", receipt.transactionHash);

    } catch (error) {
        console.error("Detailed error:", error);
        throw error;
    }
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});