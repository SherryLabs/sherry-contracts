# KOLFactoryUniswap
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/ef85f626b2f11fa0f36e09ddd8fdd3d9da90d8ba/contracts/kol-router/KOLFactoryUniswap.sol)

**Inherits:**
[KOLFactoryBase](/contracts/kol-router/KOLFactoryBase.sol/abstract.KOLFactoryBase.md)

*Factory for creating and managing KOL routers for Uniswap*


## Functions
### constructor

*Constructor*


```solidity
constructor(address _uniswapRouter) KOLFactoryBase(_uniswapRouter);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_uniswapRouter`|`address`|Address of Uniswap router|


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


