# KOLSwapRouterBase
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/42c75427de405d6510851a4525799e04cd6d3130/src/kol-router/KOLSwapRouterBase.sol)

**Inherits:**
ReentrancyGuard

*Abstract base contract for KOL routers*


## State Variables
### kolAddress

```solidity
address public kolAddress;
```


### factoryAddress

```solidity
address public factoryAddress;
```


### dexRouter

```solidity
address public dexRouter;
```


### fixedFeeAmount

```solidity
uint256 public fixedFeeAmount;
```


## Functions
### onlyKOL


```solidity
modifier onlyKOL();
```

### verifyFee


```solidity
modifier verifyFee(uint256 _msgValue);
```

### constructor

*Constructor*


```solidity
constructor(address _kolAddress, address _dexRouter, address _factoryAddress, uint256 _fixedFeeAmount);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_kolAddress`|`address`|Address of the KOL|
|`_dexRouter`|`address`|Address of the DEX router|
|`_factoryAddress`|`address`|Address of the factory|
|`_fixedFeeAmount`|`uint256`|Amount to be subtracted as Fee|


### updateFixedFee

*Allows the KOL to update their fixed fee*


```solidity
function updateFixedFee(uint256 _fixedFeeAmount) external onlyKOL;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_fixedFeeAmount`|`uint256`|New fixed fee amount (in wei)|


### withdrawFees

*Allows the KOL to withdraw their accumulated fees*


```solidity
function withdrawFees() external onlyKOL nonReentrant;
```

## Events
### SwapExecuted

```solidity
event SwapExecuted(address kol, address sender, uint256 fee);
```

### FeeUpdated

```solidity
event FeeUpdated(uint256 oldFee, uint256 newFee);
```

### FeesWithdrawn

```solidity
event FeesWithdrawn(uint256 amount, address recipient);
```

