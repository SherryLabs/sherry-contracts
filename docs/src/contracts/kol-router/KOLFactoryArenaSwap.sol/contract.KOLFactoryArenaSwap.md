# KOLFactoryArenaSwap
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/0c0c474e6eb8ad05cc12c42ac3f6490171a2e4a7/contracts/kol-router/KOLFactoryArenaSwap.sol)

**Inherits:**
[KOLFactoryBase](/contracts/kol-router/KOLFactoryBase.sol/abstract.KOLFactoryBase.md)

*Factory for creating and managing KOL routers for ArenaSwap*


## Functions
### constructor

*Constructor*


```solidity
constructor(address _arenaSwapRouter) KOLFactoryBase(_arenaSwapRouter);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_arenaSwapRouter`|`address`|Address of ArenaSwap router|


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


