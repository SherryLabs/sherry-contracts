import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { getContractAddress, SHERRY_FUNDATION_ADDRESS, SHERRY_TREASURY_ADDRESS } from "../../utils/constants";
import { avalanche, avalancheFuji } from "viem/chains";
import hre from "hardhat";

const KOLFactoryTraderJoeModule = buildModule(
  "KOLFactoryTraderJoeModule",
  (m) => {
    let joeRouter: string | undefined;

    switch (hre.network.name) {
      case "avalanche":
        joeRouter = getContractAddress("TRADER_JOE_ROUTER", avalanche.id);
        break;
      case "avalancheFuji":
        joeRouter = getContractAddress("TRADER_JOE_ROUTER", avalancheFuji.id);
        break;
      case "hardhat":
        joeRouter = getContractAddress("TRADER_JOE_ROUTER", avalanche.id);
        break;
      default:
        throw new Error(`Unsupported network: ${hre.network.name}`);
    }

    if (!joeRouter) {
      throw new Error("TRADER_JOE_ROUTER is not defined in the constants variables");
    }

    const kolFactory = m.contract("KOLFactoryTraderJoe", [joeRouter, SHERRY_FUNDATION_ADDRESS, SHERRY_TREASURY_ADDRESS], {});
    return { kolFactory };
  }
);

export default KOLFactoryTraderJoeModule;
