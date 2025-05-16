# KOLFactoryTraderJoe
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/abea0d8e26a21a2127d6a1d9e961e252da35642b/contracts/kol-router/KOLFactoryTraderJoe.sol)

**Inherits:**
[KOLFactoryBase](/contracts/kol-router/KOLFactoryBase.sol/abstract.KOLFactoryBase.md)

*Factory for creating and managing KOL routers for Trader Joe*


## Functions
### constructor

*Constructor*


```solidity
constructor(address _traderJoeRouter) KOLFactoryBase(_traderJoeRouter);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_traderJoeRouter`|`address`|Address of Trader Joe router|


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


