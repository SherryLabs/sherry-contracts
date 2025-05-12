# IJoeRouter02
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/7488ae397dbcaa4df700f0dbbfff7f6537916c5a/contracts/kol-router/interfaces/IJoeRouter02.sol)


## Functions
### swapExactAVAXForTokens


```solidity
function swapExactAVAXForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline)
    external
    payable
    returns (uint256[] memory amounts);
```

### swapAVAXForExactTokens


```solidity
function swapAVAXForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline)
    external
    payable
    returns (uint256[] memory amounts);
```

### swapExactTokensForAVAX


```solidity
function swapExactTokensForAVAX(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
) external returns (uint256[] memory amounts);
```

### swapTokensForExactAVAX


```solidity
function swapTokensForExactAVAX(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
) external returns (uint256[] memory amounts);
```

### swapExactTokensForTokens


```solidity
function swapExactTokensForTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
) external returns (uint256[] memory amounts);
```

### swapTokensForExactTokens


```solidity
function swapTokensForExactTokens(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
) external returns (uint256[] memory amounts);
```

