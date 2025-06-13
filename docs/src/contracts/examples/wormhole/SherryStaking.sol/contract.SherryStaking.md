# SherryStaking
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/390adef083cf3e2fd6de18cb4a729a02cfd3c226/contracts/examples/wormhole/SherryStaking.sol)

**Inherits:**
Ownable

This contract allows users to stake tokens and earn rewards.


## State Variables
### stakingToken

```solidity
IERC20 public stakingToken;
```


### rewardToken

```solidity
IERC20 public rewardToken;
```


### rewardRate

```solidity
uint256 public rewardRate;
```


### lastUpdateBlock

```solidity
uint256 public lastUpdateBlock;
```


### rewardPerTokenStored

```solidity
uint256 public rewardPerTokenStored;
```


### userStake

```solidity
mapping(address => uint256) public userStake;
```


### userRewardPerTokenPaid

```solidity
mapping(address => uint256) public userRewardPerTokenPaid;
```


### rewards

```solidity
mapping(address => uint256) public rewards;
```


### _totalSupply

```solidity
uint256 private _totalSupply;
```


## Functions
### constructor


```solidity
constructor(address _stakingToken, address _rewardToken, uint256 _rewardRate) Ownable(msg.sender);
```

### updateReward


```solidity
modifier updateReward(address account);
```

### rewardPerToken


```solidity
function rewardPerToken() public view returns (uint256);
```

### earned


```solidity
function earned(address account) public view returns (uint256);
```

### stake


```solidity
function stake(uint256 amount) external updateReward(msg.sender);
```

### withdraw


```solidity
function withdraw(uint256 amount) public updateReward(msg.sender);
```

### getReward


```solidity
function getReward() public updateReward(msg.sender);
```

### exit


```solidity
function exit() external;
```

## Events
### Staked

```solidity
event Staked(address indexed user, uint256 amount);
```

### Withdrawn

```solidity
event Withdrawn(address indexed user, uint256 amount);
```

### RewardPaid

```solidity
event RewardPaid(address indexed user, uint256 reward);
```

