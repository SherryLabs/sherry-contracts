import { buildModule } from "@nomicfoundation/ignition-core";
import hre from "hardhat";

const SherryOnboardingModule = buildModule(
  "SherryOnboardingModule",
  (m) => {

    const receiverAddress = "0xe0e07c70b7fB31d58AFf69C1750520baebaa632D";
    const args = [receiverAddress];
    const onboardingContract = m.contract("SherryBetaOnboarding", args, {});

    return { onboardingContract };
  });

  export default SherryOnboardingModule;