// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title ILBRouter
 * @dev Interface for Trader Joe V2.x router
 */
interface ILBRouter {
    enum Version {
        V1,         // JoeV1 (Uniswap V2 AMM)
        V2,         // JoeV2 first version
        V2_1,       // JoeV2.1 with slightly different bin formulas
        V2_2        // JoeV2.2 latest version
    }

    struct Path {
        IERC20[] tokenPath;       // Token path for the swap
        uint256[] pairBinSteps;   // BinSteps for each pair in the path
        Version[] versions;       // DEX versions for each pair
    }

    function swapExactNATIVEForTokens(
        uint256 amountOutMin,
        Path memory path,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountOut);

    function swapExactTokensForNATIVE(
        uint256 amountIn,
        uint256 amountOutMinNATIVE,
        Path memory path,
        address to,
        uint256 deadline
    ) external returns (uint256 amountOut);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        Path memory path,
        address to,
        uint256 deadline
    ) external returns (uint256 amountOut);

    function swapNATIVEForExactTokens(
        uint256 amountOut,
        Path memory path,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountIn);

    function swapTokensForExactNATIVE(
        uint256 amountOutNATIVE,
        uint256 amountInMax,
        Path memory path,
        address to,
        uint256 deadline
    ) external returns (uint256 amountIn);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        Path memory path,
        address to,
        uint256 deadline
    ) external returns (uint256 amountIn);

    function getSwapOut(
        address lbPair,
        uint256 amountIn,
        bool swapForY
    ) external view returns (uint256 amountInToBin, uint256 amountOut, uint256 fee);
}