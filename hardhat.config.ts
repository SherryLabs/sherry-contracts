import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-viem";
import * as dotenv from "dotenv"

dotenv.config();

const deployer = process.env.DEPLOYER_KEY || "";

if (!deployer) {
  throw new Error("DEPLOYER_API_KEY env variable is not set");
}

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.25",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
      {
        version: "0.8.29",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
    ]
  },
  networks: {
    avalanche: {
      url: "https://api.avax.network/ext/bc/C/rpc",
      accounts: [deployer],
    },
    sepolia: {
      url: "https://ethereum-sepolia.publicnode.com",
      accounts: [deployer],
      chainId: 11155111
    },
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
    },
    celo: {
      url: "https://forno.celo.org",
      accounts: [deployer],
    },
    monadTestnet: {
      url: "https://testnet-rpc.monad.xyz/",
      accounts: [deployer],
    }
  },
  sourcify: {
    enabled: true,
    apiUrl: "https://sourcify-api-monad.blockvision.org",
    browserUrl: "https://testnet.monadexplorer.com/"
  },
  etherscan: {
    apiKey: {
      celoAlfajores: process.env.CELO_ALFAJORES_ETHERSCAN_API_KEY || "",
      celo: process.env.CELO_ALFAJORES_ETHERSCAN_API_KEY || "",
      avalancheFuji: process.env.AVALANCHE_FUJI_ETHERSCAN_API_KEY || "",
      avalanche: process.env.AVALANCHE_FUJI_ETHERSCAN_API_KEY || "",
      sepolia: process.env.SEPOLIA_ETHERSCAN_API_KEY || "",
    },
    customChains: [
      {
        network: "avalancheFuji",
        chainId: 43113,
        urls: {
          apiURL: "https://api.avascan.info/v2/network/testnet/evm/43113/etherscan",
          browserURL: "https://testnet.snowtrace.io"
        }
      },
      {
        network: "avalanche",
        chainId: 43114,
        urls: {
          apiURL: "https://api.avascan.info/v2/network/mainnet/evm/43114/etherscan",
          browserURL: "https://snowtrace.io"
        }
      },
      {
        network: "celoAlfajores",
        chainId: 44787,
        urls: {
          apiURL: "https://api-alfajores.celoscan.io/api",
          browserURL: "https://alfajores.celoscan.io",
        }
      },
      {
        network: "celo",
        chainId: 42220,
        urls: {
          apiURL: "https://api.celoscan.io/api",
          browserURL: "https://celoscan.io",
        }
      },
      {
        network: "sepolia",
        chainId: 11155111,
        urls: {
          apiURL: "https://api-sepolia.etherscan.io/api",
          browserURL: "https://sepolia.etherscan.io",
        }
      },
    ]
  }
};

export default config;