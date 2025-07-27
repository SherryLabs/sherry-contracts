/**
 * RegisterSenderInReceiver.ts
 * 
 * This script registers message sender contracts from other chains as authorized
 * senders in a message receiver contract on the current network.
 * 
 * Purpose:
 * - Enables cross-chain messaging by allowing receiver contracts to accept messages
 *   from specific sender contracts on other chains
 * - Automatically discovers and registers all available sender contracts across
 *   supported blockchain networks
 * 
 * How it works:
 * 1. Identifies the current network as the receiver chain
 * 2. Finds all other supported chains of the same type (mainnet/testnet) that could be senders
 * 3. For each potential sender chain:
 *    - Looks for deployed SL1MessageSender contract
 *    - Registers it in the current chain's SL1MessageReceiver contract
 *    - Uses Wormhole chain IDs for cross-chain identification
 * 
 * Usage:
 * npx hardhat run scripts/wormhole/RegisterSenderInReceiver.ts --network <receiver-network>
 * 
 * Example:
 * npx hardhat run scripts/wormhole/RegisterSenderInReceiver.ts --network avalanche
 * 
 * This will register mainnet senders from celo, base, mainnet in the avalanche receiver
 * (testnet chains like sepolia, fuji are excluded for mainnet receivers)
 * 
 * Requirements:
 * - SL1MessageReceiver contract must be deployed on the target network
 * - SL1MessageSender contracts should be deployed on source networks
 * - Deployment artifacts must exist in ignition/deployments/chain-{chainId}/
 * 
 * Security Note:
 * - Only registers senders that have valid deployment artifacts
 * - Uses Wormhole's standardized chain IDs for secure cross-chain identification
 * - Separates mainnet and testnet environments (no cross-registration)
 * - Each sender registration requires an on-chain transaction
 */

const hre = require("hardhat");
import { chains } from "../../utils/chains";
import * as fs from 'fs';
import path from 'path';

/**
 * Main function that registers all available sender contracts in the receiver contract
 * on the current network
 */
async function main() {
    // Get the current network name from Hardhat configuration
    const receiverName = hre.network.name;

    // Find the receiver chain configuration from supported chains
    const chainReceiver = chains.find((chain) => chain.name === receiverName);

    if (!chainReceiver) throw new Error("Chain ID is required");

    // Get all chains except the current receiver chain as potential senders
    // Only include chains of the same type (mainnet with mainnet, testnet with testnet)
    const senderChains = chains.filter((chain) => 
        chain.chainId !== chainReceiver.chainId && 
        chain.mainnet === chainReceiver.mainnet
    );

    // Load the receiver contract deployment data from local artifacts
    const receiverData = JSON.parse(
        fs.readFileSync(
            path.resolve(__dirname, `../../ignition/deployments/chain-${chainReceiver.chainId}/deployed_addresses.json`),
            'utf8'
        )
    );

    if (!receiverData) {
        throw new Error("Receiver Data is required");
    }

    // Get the receiver contract address and create contract instance
    const receiverAddress = receiverData["SL1MessageReceiverModule#SL1MessageReceiver"]
    
    if (!receiverAddress) {
        throw new Error(`SL1MessageReceiver contract not found in deployment artifacts for ${receiverName}. Available keys: ${Object.keys(receiverData).join(', ')}`);
    }
    
    const receiver = await hre.ethers.getContractAt("SL1MessageReceiver", receiverAddress);

    const networkType = chainReceiver.mainnet ? 'mainnet' : 'testnet';
    console.log(`Registering ${networkType} senders for receiver on ${receiverName} (${chainReceiver.chainId})`);

    // Iterate through each potential sender chain and register it
    for (const senderChain of senderChains) {
        try {
            // Try to load sender contract deployment data
            const senderData = JSON.parse(
                fs.readFileSync(
                    path.resolve(__dirname, `../../ignition/deployments/chain-${senderChain.chainId}/deployed_addresses.json`),
                    'utf8'
                )
            );

            // Get sender contract address
            const senderAddress = senderData["SL1MessageSenderModule#SL1MessageSender"];
            if (!senderAddress) {
                console.log(`⚠️ Skipping ${senderChain.name}: No sender contract deployed`);
                continue;
            }

            // Format sender address to 32 bytes (required by Wormhole)
            const senderFormattedAddress = hre.ethers.zeroPadValue(senderAddress, 32);

            // Register the sender in the receiver contract
            // Uses Wormhole chain ID for cross-chain identification
            const tx = await receiver.setRegisteredSender(
                senderChain.chainIdWh,
                senderFormattedAddress
            );

            // Wait for transaction confirmation
            await tx.wait();

            console.log(`✅ Registered sender from ${senderChain.name} (${senderChain.chainId}) - tx: ${tx.hash}`);
        } catch (error) {
            // Skip chains that don't have deployments or have other issues
            console.log(`⚠️ Skipping ${senderChain.name}: ${error}`);
        }
    }

    console.log("All available senders registered in receiver contract");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
