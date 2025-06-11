import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { getContractAddress } from "../../utils/constants";
import { avalanche, avalancheFuji } from "viem/chains";
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

    const kolFactory = m.contract("KOLFactoryArenaSwap", [arenaSwapRouter], {});
    return { kolFactory };
  }
);

export default KOLFactoryArenaSwapModule;
