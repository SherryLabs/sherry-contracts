# KOLFactoryPangolin
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/abea0d8e26a21a2127d6a1d9e961e252da35642b/contracts/kol-router/KOLFactoryPangolin.sol)

**Inherits:**
[KOLFactoryBase](/contracts/kol-router/KOLFactoryBase.sol/abstract.KOLFactoryBase.md)

*Factory for creating and managing KOL routers for Pangolin*


## Functions
### constructor

*Constructor*


```solidity
constructor(address _pangolinRouter) KOLFactoryBase(_pangolinRouter);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_pangolinRouter`|`address`|Address of Pangolin router|


### _createRouterImplementation

*Creates the specific router implementation*


```solidity
function _createRouterImplementation(address _kolAddress, uint256 _fixedFeeAmount)
    internal
    override
    returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_kolAddress`|`address`|Address of the KOL|
|`_fixedFeeAmount`|`uint256`|Amount to be subtracted as Fee|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|Address of the new router|


