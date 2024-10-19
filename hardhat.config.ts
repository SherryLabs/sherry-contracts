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
  ignition: { 
    requiredConfirmations: 1,
  },
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

  },
};

export default config;
