# KOLRouterPangolinV2
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/390adef083cf3e2fd6de18cb4a729a02cfd3c226/contracts/kol-router/KOLRouterPangolinV2.sol)

**Inherits:**
[KOLSwapRouterBase](/contracts/kol-router/KOLSwapRouterBase.sol/abstract.KOLSwapRouterBase.md)

Router for KOLs that supports direct swaps via Pangolin v2 using IPangolinRouter.

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
|`_dexRouter`|`address`|Address of the Pangolin UniversalRouter|
|`_factoryAddress`|`address`|Address of the factory that deployed this router|
|`_fixedFeeAmount`|`uint256`|Amount to be subtracted as Fee|


### swapExactTokensForTokens

Swap exact amount of ERC20 tokens for another ERC20 token.


```solidity
function swapExactTokensForTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
) external payable nonReentrant verifyFee(msg.value) returns (uint256[] memory amounts);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amounts`|`uint256[]`|The amount of destination token received.|


### swapTokensForExactTokens

Swap up to a maximum amount of ERC20 tokens to get a fixed amount of another ERC20 token.


```solidity
function swapTokensForExactTokens(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
) external payable verifyFee(msg.value) nonReentrant returns (uint256[] memory amounts);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amounts`|`uint256[]`|Array of token amounts used in the swap path.|


### swapExactAVAXForTokens

Swap exact native tokens for ERC20 tokens.

*Deducts fee and forwards the remaining native value to Pangolin router.*


```solidity
function swapExactAVAXForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline)
    external
    payable
    nonReentrant
    verifyFee(msg.value)
    returns (uint256[] memory amounts);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amounts`|`uint256[]`|The amount of tokens received from the swap.|


### swapTokensForExactAVAX

Swap up to a maximum amount of ERC20 tokens for a fixed amount of native tokens.


```solidity
function swapTokensForExactAVAX(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
) external returns (uint256[] memory amounts);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amounts`|`uint256[]`|Array containing input amounts per swap hop.|


### swapExactTokensForAVAX

Swap exact amount of ERC20 tokens for native tokens.

*Pulls tokens from user, approves DEX, and executes the swap.*


```solidity
function swapExactTokensForAVAX(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
) external payable nonReentrant verifyFee(msg.value) returns (uint256[] memory amounts);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amounts`|`uint256[]`|The amount of native tokens received.|


### swapAVAXForExactTokens

Swap native tokens for exact ERC20 token amount.

*Refunds leftover AVAX if overpaid.*


```solidity
function swapAVAXForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline)
    external
    payable
    verifyFee(msg.value)
    nonReentrant
    returns (uint256[] memory amounts);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amounts`|`uint256[]`|Array containing input amounts per swap hop.|


### receive

*Allows receiving native tokens (e.g., AVAX) in case of refund or dust from swaps.*


```solidity
receive() external payable;
```

