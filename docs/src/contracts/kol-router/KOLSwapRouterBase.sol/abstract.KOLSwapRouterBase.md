# KOLSwapRouterBase
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/ac3659d9daf69f5807477dfb4ad35c396dc00c1f/contracts/kol-router/KOLSwapRouterBase.sol)

**Inherits:**
ReentrancyGuard

*Abstract base contract for KOL routers with percentage-based fees*


## State Variables
### kolAddress

```solidity
address public kolAddress;
```


### factory

```solidity
IKOLFactory public factory;
```


### dexRouter

```solidity
address public dexRouter;
```


### sherryFoundationAddress

```solidity
address public sherryFoundationAddress;
```


### sherryTreasuryAddress

```solidity
address public sherryTreasuryAddress;
```


## Functions
### onlyKOL


```solidity
modifier onlyKOL();
```

### constructor

*Constructor*


```solidity
constructor(
    address _kolAddress,
    address _dexRouter,
    address _factoryAddress,
    address _sherryFoundationAddress,
    address _sherryTreasuryAddress
);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_kolAddress`|`address`|Address of the KOL|
|`_dexRouter`|`address`|Address of the DEX router|
|`_factoryAddress`|`address`|Address of the factory|
|`_sherryFoundationAddress`|`address`|Address of Sherry Foundation|
|`_sherryTreasuryAddress`|`address`|Address of Sherry Treasury|


### _deductFees

*Calculates and deducts fees from input amount*


```solidity
function _deductFees(uint256 inputAmount, address tokenAddress) internal returns (NetAmount memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`inputAmount`|`uint256`|The original input amount|
|`tokenAddress`|`address`|Address of the token (address(0) for native)|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`NetAmount`|netAmount Amount after fees deduction and fee data|


### calculateNetAmount

Calculates the net amount after deducting total fees from the given input amount.


```solidity
function calculateNetAmount(uint256 _inputAmount) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_inputAmount`|`uint256`|The original amount before fees.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The net amount after fee deduction.|


### withdrawKOLFees

*Allows the KOL to withdraw their accumulated fees for multiple tokens including native*


```solidity
function withdrawKOLFees(address[] calldata tokenAddresses) external onlyKOL nonReentrant;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenAddresses`|`address[]`|Array of token addresses (address(0) for native)|


### getKOLFeeBalance

*Get KOL fee balance for a specific token*


```solidity
function getKOLFeeBalance(address tokenAddress) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenAddress`|`address`|Address of the token (address(0) for native)|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Fee balance|


### getKOLFeeBalances

*Get KOL fee balances for multiple tokens*


```solidity
function getKOLFeeBalances(address[] calldata tokenAddresses) external view returns (uint256[] memory balances);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenAddresses`|`address[]`|Array of token addresses|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`balances`|`uint256[]`|Array of fee balances|


## Events
### SwapExecuted

```solidity
event SwapExecuted(
    address indexed kol,
    address indexed trader,
    address tokenIn,
    address indexed tokenOut,
    uint256 kolFee,
    uint256 foundationFee,
    uint256 treasuryFee
);
```

## Structs
### NetAmount

```solidity
struct NetAmount {
    uint256 netAmount;
    uint256 kolFee;
    uint256 foundationFee;
    uint256 treasuryFee;
}
```

