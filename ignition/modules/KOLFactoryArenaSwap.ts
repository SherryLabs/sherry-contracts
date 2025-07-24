import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { getContractAddress, SHERRY_FUNDATION_ADDRESS, SHERRY_TREASURY_ADDRESS } from "../../utils/constants";
import { avalanche } from "viem/chains";
import hre from "hardhat";

const KOLFactoryArenaSwapModule = buildModule(
  "KOLFactoryArenaSwapModule",
  (m) => {
    let arenaSwapRouter: string | undefined;

    switch (hre.network.name) {
      case "avalanche":
        arenaSwapRouter = getContractAddress("ARENA_SWAP_ROUTER", avalanche.id);
        break;
      case "hardhat":
        arenaSwapRouter = getContractAddress("ARENA_SWAP_ROUTER", avalanche.id);
        break;
      default:
        throw new Error(`Unsupported network: ${hre.network.name}`);
    }

    if (!arenaSwapRouter) {
      throw new Error("ARENA_SWAP_ROUTER is not defined in the constants variables");
    }

    const args = [arenaSwapRouter, SHERRY_FUNDATION_ADDRESS, SHERRY_TREASURY_ADDRESS];
    const kolFactory = m.contract("KOLFactoryArenaSwap", args, {});

    console.log("\nTo verify the contract, run:");
    console.log(
      `npx hardhat verify --network ${hre.network.name} CONTRACT_ADDRESS ${args.join(" ")}`
    );

    return { kolFactory };
  }
);

export default KOLFactoryArenaSwapModule;