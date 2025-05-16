import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { getContractAddress } from "../../utils/constants";
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

    const kolFactory = m.contract("KOLFactoryPangolin", [pangolinRouter], {});
    return { kolFactory };
  }
);

export default KOLFactoryPangolinModule;
