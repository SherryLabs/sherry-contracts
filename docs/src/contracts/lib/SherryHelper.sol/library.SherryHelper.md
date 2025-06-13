# SherryHelper
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/390adef083cf3e2fd6de18cb4a729a02cfd3c226/contracts/lib/SherryHelper.sol)


## Functions
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


