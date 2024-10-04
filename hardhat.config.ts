import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";
import dotenv from "dotenv";
dotenv.config();

const PRIVATE_KEY = process.env.PRIVATE_KEY || "";
const ALCHEMY_ID = process.env.ALCHEMY_ID || "";

const config: HardhatUserConfig = {
  solidity: "0.8.25",
  defaultNetwork: "hardhat",
  networks: {
    avalancheFuji: { 
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      chainId: 43113,
      accounts: [`0x${PRIVATE_KEY}`]
    },
    avalancheMainnet: {
      url: "https://api.avax.network/ext/bc/C/rpc",
      chainId: 43114,
      accounts: [`0x${PRIVATE_KEY}`]
     },
     base: {
      url: `https://base-mainnet.g.alchemy.com/v2/${ALCHEMY_ID}`,
      chainId: 8453,
      accounts: [`0x${PRIVATE_KEY}`]
     },
     baseSepolia: {
      url: `https://base-sepolia.g.alchemy.com/v2/${ALCHEMY_ID}`,
      chainId: 84532,
      accounts: [`0x${PRIVATE_KEY}`]
     }
  }
};

export default config;
