# SL1AnyChainReceiver
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/abea0d8e26a21a2127d6a1d9e961e252da35642b/contracts/ICP/SL1AnyChainReceiver.sol)

**Inherits:**
ITeleporterReceiver

This contract receives cross-chain messages and executes the encoded function calls on the target contract.


## Functions
### receiveTeleporterMessage

Receives a cross-chain message, decodes it, and executes the function call on the target contract.


```solidity
function receiveTeleporterMessage(bytes32, address, bytes calldata message) external override;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`||
|`<none>`|`address`||
|`message`|`bytes`|The encoded message containing the target contract address and the encoded function call.|


### _getRevertMsg

Decodes the revert message from the return data.


```solidity
function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_returnData`|`bytes`|The return data from the failed function call.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|The decoded revert message.|


## Events
### MessageReceived
Emitted when a message is successfully received and executed.


```solidity
event MessageReceived(address indexed sender, bytes message);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`sender`|`address`|The address of the target contract.|
|`message`|`bytes`|The return data from the executed function call.|

### ErrorMessage
Emitted when there is an error executing the function call.


```solidity
event ErrorMessage(string message);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`message`|`string`|The error message.|

