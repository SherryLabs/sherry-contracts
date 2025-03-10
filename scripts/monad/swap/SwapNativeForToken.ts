import { parseAbi, encodePacked, parseEther, pad } from 'viem';
import hre from 'hardhat';
import dotenv from 'dotenv';

dotenv.config();

// Contract addresses
const ROUTER_ADDRESS = '0x1b1f2Bfc5e551b955F2a3F973876cEE917FB4d05' as `0x${string}`;
const TOKEN_FACTORY_ADDRESS = '0x501ee2D4AA611C906F785e10cC868e145183FCE4' as `0x${string}`;

// The token address you want to swap to
const TARGET_TOKEN = '0x83828B09e730aea59A83De8CB84B963a9Fc604a6' as `0x${string}`; // Example token, replace with actual token address

// Router ABI for swapExactIn function
const routerAbi = parseAbi([
  'function swapExactIn(bytes calldata route, address recipient, uint256 amountIn, uint256 minAmountOut, uint256 deadline, address msgSender) external payable returns (uint256)'
]);

async function main() {
  try {
    // Get wallet and client
    const [walletClient] = await hre.viem.getWalletClients();
    const publicClient = await hre.viem.getPublicClient();
    
    console.log(`Swapping native token for ${TARGET_TOKEN}`);

    // Swap parameters
    const amountIn = parseEther('0.1'); // Amount of native token to swap (0.1 MONAD)
    const minAmountOut = 0n; // Minimum amount of tokens to receive (don't use 0 in production!)
    const deadline = BigInt(Math.floor(Date.now() / 1000) + 3600); // 1 hour from now
    const recipient = walletClient.account.address;

    // Encode route: address(0) -> TOKEN_MILL (factory) -> target token
    // uint32((3 << 24) | (0 << 16) | 0) = 50331648
    const encodedRoute = encodePacked(
      ['address', 'uint32', 'address'],
      [
        '0x0000000000000000000000000000000000000000', // address(0) for native token
        50331648, // uint32((3 << 24) | (0 << 16) | 0)
        TARGET_TOKEN // The token you want to receive
      ]
    );

    console.log('Sending swap transaction...');
    console.log(`Amount In: ${amountIn} wei`);
    console.log(`Minimum Out: ${minAmountOut}`);
    console.log(`Deadline: ${deadline} (${new Date(Number(deadline) * 1000).toLocaleString()})`);
    console.log(`Recipient: ${recipient}`);

    // Execute the swap
    const tx = await walletClient.writeContract({
      address: ROUTER_ADDRESS,
      abi: routerAbi,
      functionName: 'swapExactIn',
      args: [
        encodedRoute,
        recipient,
        amountIn,
        minAmountOut,
        deadline,
        recipient
      ],
      value: amountIn // Send native token with the transaction
    });

    console.log(`Transaction sent: ${tx}`);
    
    // Wait for transaction receipt
    const receipt = await publicClient.waitForTransactionReceipt({ hash: tx });
    console.log('Transaction confirmed:', receipt);
    console.log(`Gas used: ${receipt.gasUsed}`);
    
    if (receipt.status === 'success') {
      console.log('Swap executed successfully! Check your wallet for the tokens.');
    } else {
      console.log('Swap transaction failed. Check the blockchain explorer for more details.');
    }
  } catch (error: any) {
    console.error('Error executing swap:');
    if (error.cause) {
      console.error('Error details:', error.cause);
    }
    console.error('Message:', error.message || error);
  }
}

main()
  .catch(error => {
    console.error('Script failed:', error);
    process.exitCode = 1;
  });
