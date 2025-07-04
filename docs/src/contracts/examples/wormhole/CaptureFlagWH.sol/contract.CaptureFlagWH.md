# CaptureFlagWH
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/ac3659d9daf69f5807477dfb4ad35c396dc00c1f/contracts/examples/wormhole/CaptureFlagWH.sol)


## State Variables
### owner

```solidity
address public owner;
```


### flagHolder

```solidity
address public flagHolder;
```


### flagCaptureTime

```solidity
uint256 public flagCaptureTime;
```


### flagPrice

```solidity
uint256 public flagPrice = 0.1 ether;
```


### lastParticipationTime

```solidity
mapping(address => uint256) public lastParticipationTime;
```


## Functions
### constructor


```solidity
constructor();
```

### onlyOwner


```solidity
modifier onlyOwner();
```

### canParticipate


```solidity
modifier canParticipate(address _participant);
```

### captureFlag


```solidity
function captureFlag(address _participant) public payable canParticipate(_participant);
```

### withdraw


```solidity
function withdraw() external onlyOwner;
```

### canUserParticipate


```solidity
function canUserParticipate(address _participant) external view returns (bool);
```

### setFlagPrice


```solidity
function setFlagPrice(uint256 _price) external onlyOwner;
```

### transferOwnership


```solidity
function transferOwnership(address _newOwner) external onlyOwner;
```

## Events
### FlagCaptured

```solidity
event FlagCaptured(address indexed player, uint256 timestamp);
```

