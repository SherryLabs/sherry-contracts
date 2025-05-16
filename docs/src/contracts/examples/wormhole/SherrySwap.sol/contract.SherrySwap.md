# SherrySwap
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/ef85f626b2f11fa0f36e09ddd8fdd3d9da90d8ba/contracts/examples/wormhole/SherrySwap.sol)

**Inherits:**
Ownable

This contract allows users to swap tokens using a simple AMM.


## State Variables
### tokenA

```solidity
IERC20 public tokenA;
```


### tokenB

```solidity
IERC20 public tokenB;
```


### reserveA

```solidity
uint256 public reserveA;
```


### reserveB

```solidity
uint256 public reserveB;
```


## Functions
### constructor


```solidity
constructor(address _tokenA, address _tokenB) Ownable(msg.sender);
```

### addLiquidity


```solidity
function addLiquidity(uint256 amountA, uint256 amountB) external onlyOwner;
```

### removeLiquidity


```solidity
function removeLiquidity(uint256 amountA, uint256 amountB) external onlyOwner;
```

### getAmountOut


```solidity
function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256);
```

### swap


```solidity
function swap(address tokenIn, uint256 amountIn) external;
```

## Events
### Swapped

```solidity
event Swapped(
    address indexed user, address indexed tokenIn, uint256 amountIn, address indexed tokenOut, uint256 amountOut
);
```

### LiquidityAdded

```solidity
event LiquidityAdded(address indexed user, uint256 amountA, uint256 amountB);
```

### LiquidityRemoved

```solidity
event LiquidityRemoved(address indexed user, uint256 amountA, uint256 amountB);
```

