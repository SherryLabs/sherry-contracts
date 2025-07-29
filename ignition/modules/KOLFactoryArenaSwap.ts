import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { getContractAddress } from "../../utils/constants";
import { avalanche } from "viem/chains";
import hre from "hardhat";

const KOLFactoryArenaSwapModule = buildModule(
  "KOLFactoryArenaSwapModule",
  (m) => {
    let dexRouter, sherryFundationAddress, sherryTreasuryAddress: string | undefined;

    switch (hre.network.name) {
      case "avalanche":
        dexRouter = getContractAddress("ARENA_SWAP_ROUTER", avalanche.id);
        sherryFundationAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", avalanche.id);
        sherryTreasuryAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", avalanche.id);
        break;
      case "hardhat":
        dexRouter = getContractAddress("ARENA_SWAP_ROUTER", avalanche.id);
        sherryFundationAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", avalanche.id);
        sherryTreasuryAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", avalanche.id);
        break;
      default:
        throw new Error(`Unsupported network: ${hre.network.name}`);
    }

    if (!dexRouter) {
      throw new Error("ARENA_SWAP_ROUTER is not defined in the constants variables");
    }

    const args = [dexRouter, sherryFundationAddress, sherryTreasuryAddress];
    const kolFactory = m.contract("KOLFactoryArenaSwap", args, {});

    console.log("\n==========================================================");
    console.log("To verify the contract, run:");
    console.log(
      `$ npx hardhat verify --network ${hre.network.name} CONTRACT_ADDRESS ${args.join(" ")}`
    );
    console.log("==========================================================\n");

    return { kolFactory };
  }
);

export default KOLFactoryArenaSwapModule;