# SL1MessageSender
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/390adef083cf3e2fd6de18cb4a729a02cfd3c226/contracts/wormhole/SL1MessageSender.sol)

*This contract allows sending cross-chain messages using the Wormhole Relayer.*


## State Variables
### s_wormholeRelayer

```solidity
IWormholeRelayer public s_wormholeRelayer;
```


### owner

```solidity
address public owner;
```


### GAS_LIMIT

```solidity
uint256 public GAS_LIMIT = 800_000;
```


### ORIGIN_CHAIN

```solidity
uint16 public immutable ORIGIN_CHAIN;
```


## Functions
### constructor

*Sets the Wormhole Relayer address and initializes the contract owner.*


```solidity
constructor(address _wormholeRelayer, uint16 _originChain);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_wormholeRelayer`|`address`|The address of the Wormhole Relayer contract.|
|`_originChain`|`uint16`||


### quoteCrossChainCost

Quotes the cost of sending a cross-chain message.


```solidity
function quoteCrossChainCost(uint16 _targetChain, uint256 _receiverValue, uint256 _gasLimit)
    public
    view
    returns (uint256 cost);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_targetChain`|`uint16`|The target chain ID.|
|`_receiverValue`|`uint256`||
|`_gasLimit`|`uint256`|The gas limit for the cross-chain message.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`cost`|`uint256`|The quoted cost for sending the message.|


### encodeMessage

Encodes the message to be sent cross-chain.


```solidity
function encodeMessage(address _contractToBeCalled, bytes memory _encodedFunctionCall)
    public
    view
    returns (bytes memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_contractToBeCalled`|`address`|The address of the contract to be called on the target chain.|
|`_encodedFunctionCall`|`bytes`|The encoded function call data.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes`|The encoded message.|


### sendMessage

Sends a cross-chain message with a refund option.


```solidity
function sendMessage(
    uint16 _targetChain,
    address _receiverAddress,
    address _contractToBeCalled,
    bytes memory _encodedFunctionCall,
    uint256 _gasLimit,
    uint256 _receiverValue
) external payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_targetChain`|`uint16`|The target chain ID.|
|`_receiverAddress`|`address`|The address on the target chain - WH SL1 Message Receiver.|
|`_contractToBeCalled`|`address`|The address of the contract to be called on the target chain.|
|`_encodedFunctionCall`|`bytes`|The encoded function call data.|
|`_gasLimit`|`uint256`|The gas limit for the cross-chain message.|
|`_receiverValue`|`uint256`||


### setGasLimit

Sets the gas limit for cross-chain messages.


```solidity
function setGasLimit(uint256 _gasLimit) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_gasLimit`|`uint256`|The new gas limit.|


### onlyOwner

*Modifier to restrict function access to the contract owner.*


```solidity
modifier onlyOwner();
```

## Events
### MessageSent

```solidity
event MessageSent(
    address indexed contractToBeCalled, bytes encodedFunctionCall, address destinationAddress, bytes32 destinationChain
);
```

