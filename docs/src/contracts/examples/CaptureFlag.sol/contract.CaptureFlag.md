# CaptureFlag
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/abea0d8e26a21a2127d6a1d9e961e252da35642b/contracts/examples/CaptureFlag.sol)


## State Variables
### owner

```solidity
address public owner;
```


### gameFee

```solidity
uint256 public gameFee = 0.01 ether;
```


### flagHolder

```solidity
address public flagHolder;
```


### flagCaptureTime

```solidity
uint256 public flagCaptureTime;
```


### lastParticipationTime

```solidity
mapping(address => uint256) public lastParticipationTime;
```


## Functions
### onlyOwner


```solidity
modifier onlyOwner();
```

### canParticipate


```solidity
modifier canParticipate();
```

### joinGame


```solidity
function joinGame() external payable canParticipate;
```

### captureFlag


```solidity
function captureFlag() public canParticipate;
```

### updateGameFee


```solidity
function updateGameFee(uint256 _gameFee) external onlyOwner;
```

### withdraw


```solidity
function withdraw() external onlyOwner;
```

## Events
### GameJoined

```solidity
event GameJoined(address indexed player, uint256 timestamp);
```

### FlagCaptured

```solidity
event FlagCaptured(address indexed player, uint256 timestamp);
```

