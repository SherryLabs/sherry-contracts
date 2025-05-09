# SherryHelper
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/7488ae397dbcaa4df700f0dbbfff7f6537916c5a/contracts/lib/SherryHelper.sol)


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


