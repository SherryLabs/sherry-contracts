# SL1MessageReceiver
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/ac3659d9daf69f5807477dfb4ad35c396dc00c1f/contracts/wormhole/SL1MessageReceiver.sol)

**Inherits:**
IWormholeReceiver


## State Variables
### s_wormholeRelayer

```solidity
IWormholeRelayer public s_wormholeRelayer;
```


### s_registrationOwner

```solidity
address public s_registrationOwner;
```


### s_registeredSenders

```solidity
mapping(uint16 => bytes32) public s_registeredSenders;
```


## Functions
### constructor


```solidity
constructor(address _wormholeRelayer);
```

### isRegisteredSender


```solidity
modifier isRegisteredSender(uint16 sourceChain, bytes32 sourceAddress);
```

### setRegisteredSender


```solidity
function setRegisteredSender(uint16 sourceChain, bytes32 sourceAddress) external onlyOwner;
```

### receiveWormholeMessages


```solidity
function receiveWormholeMessages(
    bytes memory payload,
    bytes[] memory,
    bytes32 sourceAddress,
    uint16 sourceChain,
    bytes32
) public payable override isRegisteredSender(sourceChain, sourceAddress);
```

### withdraw


```solidity
function withdraw() external onlyOwner;
```

### onlyOwner


```solidity
modifier onlyOwner();
```

## Events
### MessageInfoReceived

```solidity
event MessageInfoReceived(bytes32 sourceAddress, bytes payload);
```

### SourceChainLogged

```solidity
event SourceChainLogged(uint16 sourceChain, address sender);
```

### FunctionExecuted

```solidity
event FunctionExecuted(address contractToBeCalled, bytes encodedFunctionCall);
```

### FunctionCallError

```solidity
event FunctionCallError(string message);
```

### SenderRegistered

```solidity
event SenderRegistered(uint16 sourceChain, bytes32 sourceAddress);
```

### Withdraw

```solidity
event Withdraw(address indexed owner, uint256 amount);
```

