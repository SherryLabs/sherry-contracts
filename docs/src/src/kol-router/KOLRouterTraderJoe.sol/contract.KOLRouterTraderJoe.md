# KOLRouterTraderJoe
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/42c75427de405d6510851a4525799e04cd6d3130/src/kol-router/KOLRouterTraderJoe.sol)

**Inherits:**
[KOLSwapRouterBase](/src/kol-router/KOLSwapRouterBase.sol/abstract.KOLSwapRouterBase.md)

Router for KOLs that supports direct swaps via Trader Joe v1 and v2.x using ILBRouter.

*Handles both native and ERC20 swaps, applying a fixed fee in native token (e.g., AVAX).*


## Functions
### constructor

*Constructor that initializes the KOL router instance.*


```solidity
constructor(address _kolAddress, address _dexRouter, address _factoryAddress, uint256 _fixedFeeAmount)
    KOLSwapRouterBase(_kolAddress, _dexRouter, _factoryAddress, _fixedFeeAmount);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_kolAddress`|`address`|Address of the KOL associated with this router|
|`_dexRouter`|`address`|Address of the Uniswap UniversalRouter|
|`_factoryAddress`|`address`|Address of the factory that deployed this router|
|`_fixedFeeAmount`|`uint256`|Amount to be subtracted as Fee|


### swapExactNATIVEForTokens

Swap exact native tokens for ERC20 tokens.

*Deducts fee and forwards the remaining native value to Trader Joe router.*


```solidity
function swapExactNATIVEForTokens(uint256 amountOutMin, ILBRouter.Path calldata path, address to, uint256 deadline)
    external
    payable
    nonReentrant
    verifyFee(msg.value)
    returns (uint256 amountOut);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountOut`|`uint256`|The amount of tokens received from the swap.|


### swapNATIVEForExactTokens

Swap native tokens for exact ERC20 token amount.

*Refunds leftover AVAX if overpaid.*


```solidity
function swapNATIVEForExactTokens(uint256 amountOut, ILBRouter.Path calldata path, address to, uint256 deadline)
    external
    payable
    verifyFee(msg.value)
    nonReentrant
    returns (uint256[] memory amountsIn);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountsIn`|`uint256[]`|Array containing input amounts per swap hop.|


### swapExactTokensForNATIVE

Swap exact amount of ERC20 tokens for native tokens.

*Pulls tokens from user, approves DEX, and executes the swap.*


```solidity
function swapExactTokensForNATIVE(
    uint256 amountIn,
    uint256 amountOutMinNATIVE,
    ILBRouter.Path calldata path,
    address payable to,
    uint256 deadline
) external payable nonReentrant verifyFee(msg.value) returns (uint256 amountOut);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountOut`|`uint256`|The amount of native tokens received.|


### swapTokensForExactNATIVE

Swap up to a maximum amount of ERC20 tokens for a fixed amount of native tokens.


```solidity
function swapTokensForExactNATIVE(
    uint256 amountOutNATIVE,
    uint256 amountInMax,
    ILBRouter.Path calldata path,
    address payable to,
    uint256 deadline
) external payable nonReentrant verifyFee(msg.value) returns (uint256[] memory amountsIn);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountsIn`|`uint256[]`|Array containing input amounts per swap hop.|


### swapExactTokensForTokens

Swap exact amount of ERC20 tokens for another ERC20 token.


```solidity
function swapExactTokensForTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    ILBRouter.Path calldata path,
    address to,
    uint256 deadline
) external payable nonReentrant verifyFee(msg.value) returns (uint256 amountOut);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountOut`|`uint256`|The amount of destination token received.|


### swapTokensForExactTokens

Swap up to a maximum amount of ERC20 tokens to get a fixed amount of another ERC20 token.


```solidity
function swapTokensForExactTokens(
    uint256 amountOut,
    uint256 amountInMax,
    ILBRouter.Path calldata path,
    address to,
    uint256 deadline
) external payable verifyFee(msg.value) nonReentrant returns (uint256[] memory amountsIn);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountsIn`|`uint256[]`|Array of token amounts used in the swap path.|


### receive

*Allows receiving native tokens (e.g., AVAX) in case of refund or dust from swaps.*


```solidity
receive() external payable;
```

