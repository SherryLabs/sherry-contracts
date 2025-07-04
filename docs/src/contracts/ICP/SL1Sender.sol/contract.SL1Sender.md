# SL1Sender
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/ac3659d9daf69f5807477dfb4ad35c396dc00c1f/contracts/ICP/SL1Sender.sol)

This contract allows sending arbitrary messages to any contract on any blockchain using the Teleporter protocol.


## State Variables
### messenger
The Teleporter messenger contract used to send cross-chain messages.


```solidity
ITeleporterMessenger public messenger = ITeleporterMessenger(0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf);
```


## Functions
### sendMessage

Sends a cross-chain message to a specified contract on a specified blockchain.


```solidity
function sendMessage(
    address _contractToBeCalled,
    bytes calldata _encodedFunctionCall,
    address _destinationAdress,
    bytes32 _destinationChain,
    uint256 _gasLimit
) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_contractToBeCalled`|`address`|The address of the contract on the destination blockchain.|
|`_encodedFunctionCall`|`bytes`|The encoded function call to be executed on the destination contract.|
|`_destinationAdress`|`address`|The address of the destination contract.|
|`_destinationChain`|`bytes32`|The identifier of the destination blockchain.|
|`_gasLimit`|`uint256`|The gas limit for the function call on the destination blockchain.|


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


