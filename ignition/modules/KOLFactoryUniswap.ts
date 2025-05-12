import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { getContractAddress } from "../../utils/constants";
import { avalanche, avalancheFuji } from "viem/chains";
import hre from "hardhat";

const KOLFactoryUniswapModule = buildModule("KOLFactoryUniswapModule", (m) => {
  let uniRouter: string | undefined;

  switch (hre.network.name) {
    case "avalanche":
      uniRouter = getContractAddress("UNISWAP_ROUTER", avalanche.id);
      break;
    case "avalancheFuji":
      uniRouter = getContractAddress("UNISWAP_ROUTER", avalancheFuji.id);
      break;
    case "hardhat":
      uniRouter = getContractAddress("UNISWAP_ROUTER", avalanche.id);
      break;
    default:
      throw new Error(`Unsupported network: ${hre.network.name}`);
  }

  if (!uniRouter) {
    throw new Error("We couldn't find -> UNI_ROUTER");
  }

  const kolFactory = m.contract("KOLFactoryUniswap", [uniRouter], {});
  return { kolFactory };
});

export default KOLFactoryUniswapModule;
