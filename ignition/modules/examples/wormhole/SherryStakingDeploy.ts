import { buildModule } from "@nomicfoundation/hardhat-ignition/modules"

const SherryStakingDeploy = buildModule("SherryStakingDeploy", (m) => {
    // USDC as Staking
    const stakingToken = "0x2F25deB3848C207fc8E0c34035B3Ba7fC157602B"
    // SHERRY as Reward
    const rewardToken = "0x075f8Af6c27a570b4c8A94BaE72f878fc98721a5"
    // Reward Rate
    const rewardRate = 200000

    const sherryStaking = m.contract("SherryStaking",
        [stakingToken, rewardToken, rewardRate]
        , {});

    return { sherryStaking };
});

export default SherryStakingDeploy;