import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { getContractAddress, SHERRY_FUNDATION_ADDRESS, SHERRY_TREASURY_ADDRESS } from "../../utils/constants";
import { avalanche, avalancheFuji } from "viem/chains";
import hre from "hardhat";

const KOLFactoryPangolinModule = buildModule(
  "KOLFactoryPangolinModule",
  (m) => {
    let pangolinRouter: string | undefined;

    switch (hre.network.name) {
      case "avalanche":
        pangolinRouter = getContractAddress("PANGOLIN_V2_ROUTER", avalanche.id);
        break;
      case "avalancheFuji":
        pangolinRouter = getContractAddress("PANGOLIN_V2_ROUTER", avalancheFuji.id);
        break;
      case "hardhat":
        pangolinRouter = getContractAddress("PANGOLIN_V2_ROUTER", avalanche.id);
        break;
      default:
        throw new Error(`Unsupported network: ${hre.network.name}`);
    }

    if (!pangolinRouter) {
      throw new Error("PANGOLIN_V2_ROUTER is not defined in the constants variables");
    }

    const args = [pangolinRouter, SHERRY_FUNDATION_ADDRESS, SHERRY_TREASURY_ADDRESS];
    const kolFactory = m.contract("KOLFactoryPangolin", args, {});

    console.log("\nTo verify the contract, run:");
    console.log(
      `npx hardhat verify --network ${hre.network.name} CONTRACT_ADDRESS ${args.join(" ")}`
    );

    return { kolFactory };
  }
);

export default KOLFactoryPangolinModule;
