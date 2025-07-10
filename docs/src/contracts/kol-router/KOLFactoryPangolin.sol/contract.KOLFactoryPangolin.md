# KOLFactoryPangolin
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/ac3659d9daf69f5807477dfb4ad35c396dc00c1f/contracts/kol-router/KOLFactoryPangolin.sol)

**Inherits:**
[KOLFactoryBase](/contracts/kol-router/KOLFactoryBase.sol/abstract.KOLFactoryBase.md)

*Factory for creating and managing KOL routers for Pangolin*


## Functions
### constructor

*Constructor*


```solidity
constructor(address _pangolinRouter, address _sherryFoundationAddress, address _sherryTreasuryAddress)
    KOLFactoryBase(_pangolinRouter, _sherryFoundationAddress, _sherryTreasuryAddress);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_pangolinRouter`|`address`|Address of Pangolin router|
|`_sherryFoundationAddress`|`address`|Address of Sherry Foundation|
|`_sherryTreasuryAddress`|`address`|Address of Sherry Treasury|


### _createRouterImplementation

*Creates the specific router implementation*


```solidity
function _createRouterImplementation(address _kolAddress) internal override returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_kolAddress`|`address`|Address of the KOL|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|Address of the new router|


