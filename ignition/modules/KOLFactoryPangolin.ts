import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { getContractAddress } from "../../utils/constants";
import { avalanche, avalancheFuji } from "viem/chains";
import hre from "hardhat";

const KOLFactoryPangolinModule = buildModule(
  "KOLFactoryPangolinModule",
  (m) => {
    let dexRouter, sherryFundationAddress, sherryTreasuryAddress: string | undefined;

    switch (hre.network.name) {
      case "avalanche":
        dexRouter = getContractAddress("PANGOLIN_V2_ROUTER", avalanche.id);
        sherryFundationAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", avalanche.id);
        sherryTreasuryAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", avalanche.id);
        break;
      case "avalancheFuji":
        dexRouter = getContractAddress("PANGOLIN_V2_ROUTER", avalancheFuji.id);
        sherryFundationAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", avalancheFuji.id);
        sherryTreasuryAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", avalancheFuji.id);
        break;
      case "hardhat":
        dexRouter = getContractAddress("PANGOLIN_V2_ROUTER", avalanche.id);
        sherryFundationAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", avalanche.id);
        sherryTreasuryAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", avalanche.id);
        break;
      default:
        throw new Error(`Unsupported network: ${hre.network.name}`);
    }

    if (!dexRouter) {
      throw new Error("PANGOLIN_V2_ROUTER is not defined in the constants variables");
    }

    const args = [dexRouter, sherryFundationAddress, sherryTreasuryAddress];
    const kolFactory = m.contract("KOLFactoryPangolin", args, {});

    console.log("\n==========================================================");
    console.log("To verify the contract, run:");
    console.log(
      `$ npx hardhat verify --network ${hre.network.name} CONTRACT_ADDRESS ${args.join(" ")}`
    );
    console.log("==========================================================\n");

    return { kolFactory };
  }
);

export default KOLFactoryPangolinModule;
