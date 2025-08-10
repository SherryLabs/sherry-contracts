import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import hre from "hardhat";
const { BETA_ONBOARD_MINTER,BETA_ONBOARD_METADATA_URI } = process.env;


const SherryBetaOnboardingModule = buildModule(
  "SherryBetaOnboardingModule",
  (m) => {
    if (!BETA_ONBOARD_MINTER) {
      throw new Error("BETA_ONBOARD_MINTER is not defined in .env variables");
    }
    if (!BETA_ONBOARD_METADATA_URI) {
      throw new Error("BETA_ONBOARD_METADATA_URI is not defined in .env variables");
    }

    const args = [BETA_ONBOARD_METADATA_URI, BETA_ONBOARD_MINTER];
    const nftContract = m.contract("SherryBetaOnboarding", args, {});

    console.log("\n==========================================================");
    console.log("To verify the contract, run:");
    console.log(
      `$ npx hardhat verify --network ${hre.network.name} CONTRACT_ADDRESS ${args.join(" ")}`
    );
    console.log("==========================================================\n");

    return { nftContract };
  }
);

export default SherryBetaOnboardingModule;