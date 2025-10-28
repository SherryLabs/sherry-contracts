import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { getContractAddress } from "../../utils/constants";
import { somniaTestnet } from "viem/chains";
import { somnia } from "../../utils/chains";
import hre from "hardhat";

const KOLFactorySomniaModule = buildModule(
  "KOLFactorySomniaModule",
  (m) => {
    let dexRouter, sherryFundationAddress, sherryTreasuryAddress: string | undefined;

    switch (hre.network.name) {
      case "somnia":
        dexRouter = getContractAddress("SOMNIA_V2_ROUTER", somnia.id);
        sherryFundationAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", somnia.id);
        sherryTreasuryAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", somnia.id);
        break;
      case "somniaTestnet":
        dexRouter = getContractAddress("SOMNIA_V2_ROUTER", somniaTestnet.id);
        sherryFundationAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", somniaTestnet.id);
        sherryTreasuryAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", somniaTestnet.id);
        break;
      case "hardhat":
        dexRouter = getContractAddress("SOMNIA_V2_ROUTER", somnia.id);
        sherryFundationAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", somnia.id);
        sherryTreasuryAddress = getContractAddress("SHERRY_FUNDATION_ADDRESS", somnia.id);
        break;
      default:
        throw new Error(`Unsupported network: ${hre.network.name}`);
    }

    if (!dexRouter) {
      throw new Error("SOMNIA_V2_ROUTER is not defined in the constants variables");
    }

    // Deploy the implementation contract first
    const implementation = m.contract("KOLRouterSomniaV2TwoFunc", [], {});

    // Deploy the factory with the implementation address
    const factoryArgs = [dexRouter, sherryFundationAddress, sherryTreasuryAddress, implementation];
    const kolFactory = m.contract("KOLFactorySomniaCloneable", factoryArgs, {});

    console.log("\n==========================================================");
    console.log("To verify the implementation contract, run:");
    console.log(
      `$ npx hardhat verify --network ${hre.network.name} IMPLEMENTATION_ADDRESS`
    );
    console.log("\nTo verify the factory contract, run:");
    console.log(
      `$ npx hardhat verify --network ${hre.network.name} FACTORY_ADDRESS ${factoryArgs.join(" ")}`
    );
    console.log("==========================================================\n");

    return { implementation, kolFactory };
  }
);

export default KOLFactorySomniaModule;
