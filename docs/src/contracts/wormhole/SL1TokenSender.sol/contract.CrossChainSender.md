# CrossChainSender
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/ef85f626b2f11fa0f36e09ddd8fdd3d9da90d8ba/contracts/wormhole/SL1TokenSender.sol)

**Inherits:**
TokenSender


## State Variables
### GAS_LIMIT

```solidity
uint256 constant GAS_LIMIT = 250_000;
```


## Functions
### constructor


```solidity
constructor(address _wormholeRelayer, address _tokenBridge, address _wormhole)
    TokenBase(_wormholeRelayer, _tokenBridge, _wormhole);
```

### quoteCrossChainDeposit


```solidity
function quoteCrossChainDeposit(uint16 _targetChain) public view returns (uint256 cost);
```

### sendCrossChainTokenAndCall


```solidity
function sendCrossChainTokenAndCall(
    uint16 _targetChain,
    address _targetReceiver,
    uint256 _amount,
    address _token,
    address _contractToBeCalled,
    bytes memory _encodedFunctionCall
) public payable;
```

### createArbitraryMessage

Creates an arbitrary message to be sent to a specified contract.


```solidity
function createArbitraryMessage(address _contractToBeCalled, bytes memory _encodedFunctionCall)
    public
    pure
    returns (bytes memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_contractToBeCalled`|`address`|The address of the contract on the destination blockchain.|
|`_encodedFunctionCall`|`bytes`|The encoded function call to be executed on the destination contract.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes`|The encoded arbitrary message.|


### sendCrossChainDeposit


```solidity
function sendCrossChainDeposit(
    uint16 _targetChain,
    address _targetReceiver,
    address _to,
    uint256 _amount,
    address _token
) public payable;
```

