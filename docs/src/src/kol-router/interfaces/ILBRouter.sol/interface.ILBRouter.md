# ILBRouter
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/42c75427de405d6510851a4525799e04cd6d3130/src/kol-router/interfaces/ILBRouter.sol)


## Functions
### swapExactTokensForTokens


```solidity
function swapExactTokensForTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    Path memory path,
    address to,
    uint256 deadline
) external returns (uint256 amountOut);
```

### swapExactTokensForNATIVE


```solidity
function swapExactTokensForNATIVE(
    uint256 amountIn,
    uint256 amountOutMinNATIVE,
    Path memory path,
    address payable to,
    uint256 deadline
) external returns (uint256 amountOut);
```

### swapExactNATIVEForTokens


```solidity
function swapExactNATIVEForTokens(uint256 amountOutMin, Path memory path, address to, uint256 deadline)
    external
    payable
    returns (uint256 amountOut);
```

### swapTokensForExactTokens


```solidity
function swapTokensForExactTokens(
    uint256 amountOut,
    uint256 amountInMax,
    Path memory path,
    address to,
    uint256 deadline
) external returns (uint256[] memory amountsIn);
```

### swapTokensForExactNATIVE


```solidity
function swapTokensForExactNATIVE(
    uint256 amountOut,
    uint256 amountInMax,
    Path memory path,
    address payable to,
    uint256 deadline
) external returns (uint256[] memory amountsIn);
```

### swapNATIVEForExactTokens


```solidity
function swapNATIVEForExactTokens(uint256 amountOut, Path memory path, address to, uint256 deadline)
    external
    payable
    returns (uint256[] memory amountsIn);
```

## Structs
### Path

```solidity
struct Path {
    uint256[] pairBinSteps;
    Version[] versions;
    IERC20[] tokenPath;
}
```

## Enums
### Version

```solidity
enum Version {
    V1,
    V2,
    V2_1,
    V2_2
}
```

