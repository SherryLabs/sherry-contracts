import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";

const config: HardhatUserConfig = {
  solidity: "0.8.25",
  defaultNetwork: "hardhat",
  networks: {
    avalancheFuji: { 
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      chainId: 43113,
      accounts: []
    },
    avalancheMainnet: {
      url: "https://api.avax.network/ext/bc/C/rpc",
      chainId: 43114,
      accounts: []
     },
  }
};

export default config;
