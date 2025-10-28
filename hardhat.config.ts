import { HardhatUserConfig } from "hardhat/config";
import {
  base,
  baseSepolia,
  avalanche,
  avalancheFuji,
  celo,
  celoAlfajores,
  sepolia,
  mainnet
} from "viem/chains"
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-viem";
import * as dotenv from "dotenv"
import { somnia } from "./utils/chains";

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
      url: avalanche.rpcUrls.default.http[0],
      accounts: [deployer],
      chainId: avalanche.id,
    },
    avalancheFuji: {
      url: avalancheFuji.rpcUrls.default.http[0],
      accounts: [deployer],
      chainId: avalancheFuji.id
    },
    mainnet: {
      url: mainnet.rpcUrls.default.http[0],
      accounts: [deployer],
      chainId: mainnet.id
    },
    sepolia: {
      url: sepolia.rpcUrls.default.http[0],
      accounts: [deployer],
      chainId: sepolia.id
    },
    base: {
      url: base.rpcUrls.default.http[0],
      accounts: [deployer],
      chainId: base.id
    },
    baseSepolia: {
      url: baseSepolia.rpcUrls.default.http[0],
      accounts: [deployer],
      chainId: baseSepolia.id
    },
    celo: {
      url: celo.rpcUrls.default.http[0],
      accounts: [deployer],
      chainId: celo.id
    },
    celoAlfajores: {
      url: celoAlfajores.rpcUrls.default.http[0],
      accounts: [deployer],
      chainId: celoAlfajores.id
    },
    sl1Testnet: {
      url: `https://subnets.avax.network/sl1/testnet/rpc`,
      accounts: [deployer],
      chainId: 3030
    },
    echoTestnet: {
      url: "https://subnets.avax.network/echo/testnet/rpc",
      accounts: [deployer],
    },
    dispatchTestnet: {
      url: "https://subnets.avax.network/dispatch/testnet/rpc",
      accounts: [deployer],
    },
    monadTestnet: {
      url: "https://testnet-rpc.monad.xyz/",
      accounts: [deployer],
    },
    somniaTestnet: {
      url: "https://dream-rpc.somnia.network",
      accounts: [deployer],
      chainId: 50312
    },
    somnia: {
      url: "https://somnia-rpc.publicnode.com",
      accounts: [deployer],
      chainId: 5031
    },
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
      somniaTestnet: "empty",
      somnia: "empty",
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
      {
        network: "somnia-testnet",
        chainId: 50312,
        urls: {
          apiURL: "https://verify-contract.xangle.io/somnia/api",
          browserURL: "https://somnia-explorer.xangle.io"
        }
      },
      {
        network: "somnia",
        chainId: 5031,
        urls: {
          apiURL: "https://verify-contract.xangle.io/somnia/api",
          browserURL: "https://somnia-explorer.xangle.io"
        }
      }
    ]
  }
};

export default config;