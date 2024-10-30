import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv"

dotenv.config();

const deployer = process.env.DEPLOYER_KEY || "";

if (!deployer) {
  throw new Error("DEPLOYER_API_KEY env variable is not set");
}

const config: HardhatUserConfig = {
  solidity: "0.8.25",
  /*
  ignition: { 
    requiredConfirmations: 1,
  },
  */

  networks: {
    sl1Testnet: {
      url: `https://subnets.avax.network/sl1/testnet/rpc`,
      accounts: [deployer],
      chainId: 3030
    },
    avalancheFuji: {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      accounts: [deployer],
    },
    echoTestnet: {
      url: "https://subnets.avax.network/echo/testnet/rpc",
      accounts: [deployer],
    },
    dispatchTestnet: {
      url: "https://subnets.avax.network/dispatch/testnet/rpc",
      accounts: [deployer],
    },
    celoAlfajores: {
      url: "https://alfajores-forno.celo-testnet.org",
      accounts: [deployer],
    }
  },
  /*
  sourcify: {
    enabled: true
  },
 */
  etherscan: {
    apiKey: {
      celoAlfajores: process.env.CELO_ALFAJORES_ETHERSCAN_API_KEY || "",
      avalancheFuji: process.env.AVALANCHE_FUJI_ETHERSCAN_API_KEY || "",
    },
    customChains: [
      {
        network: "avalancheFuji",
        chainId: 43113,
        urls: {
          apiURL: "https://api.avascan.info/v2/network/testnet/evm/43113/etherscan",
          browserURL: "https://cchain.explorer.avax-test.network"
        }
      },

      {
        network: "celoAlfajores",
        chainId: 44787,
        urls: {
          apiURL: "https://api-alfajores.celoscan.io/api",
          browserURL: "https://alfajores.celoscan.io",
        }
      }
    ]
  }


};

export default config;
