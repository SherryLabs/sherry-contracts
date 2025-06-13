# KOLRouterUniswap
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/390adef083cf3e2fd6de18cb4a729a02cfd3c226/contracts/kol-router/KOLRouterUniswap.sol)

**Inherits:**
[KOLSwapRouterBase](/contracts/kol-router/KOLSwapRouterBase.sol/abstract.KOLSwapRouterBase.md)


## State Variables
### targetApprove

```solidity
address public targetApprove;
```


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


### executeNATIVEIn

Executes a swap where the user sends NATIVE token (e.g., AVAX) as input.

*Subtracts the fixed fee from msg.value and forwards the remaining value to UniversalRouter.*


```solidity
function executeNATIVEIn(bytes calldata commands, bytes[] calldata inputs, uint256 deadline)
    external
    payable
    nonReentrant
    verifyFee(msg.value);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`commands`|`bytes`|Encoded commands for UniversalRouter|
|`inputs`|`bytes[]`|Encoded inputs for each command|
|`deadline`|`uint256`|Unix timestamp after which the swap is invalid|


### executeTokenIn

Executes a swap where the user sends ERC20 token as input.

*Transfers the input tokens from the user to this contract, approves Permit2 to use them, and forwards calldata to UniversalRouter.*


```solidity
function executeTokenIn(
    bytes calldata commands,
    bytes[] calldata inputs,
    uint256 deadline,
    address tokenIn,
    uint256 amountIn
) external payable nonReentrant verifyFee(msg.value);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`commands`|`bytes`|Encoded commands for UniversalRouter|
|`inputs`|`bytes[]`|Encoded inputs for each command|
|`deadline`|`uint256`|Unix timestamp after which the swap is invalid|
|`tokenIn`|`address`|Address of the ERC20 token to swap from|
|`amountIn`|`uint256`|Amount of the ERC20 token to transfer and use|


### setTargetApprove


```solidity
function setTargetApprove(address _target) public;
```

### receive

Allows this contract to receive NATIVE tokens (e.g., AVAX)

*Used to receive refund dust from UniversalRouter, if any*


```solidity
receive() external payable;
```

