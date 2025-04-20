// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./IKOLSwapRouterBase.sol";
import "./ILBRouter.sol";

/**
 * @title IKOLSwapRouterV2
 * @dev Interface for KOL router V2 (Trader Joe V2.x)
 */
interface IKOLSwapRouterV2 is IKOLSwapRouterBase {
    // Swap functions for Trader Joe V2.x
    function swapExactNATIVEForTokens(
        uint256 amountOutMin,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountOut);

    function swapNATIVEForExactTokens(
        uint256 amountOut,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountIn);

    function swapExactTokensForNATIVE(
        uint256 amountIn,
        uint256 amountOutMinNATIVE,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountOut);

    function swapTokensForExactNATIVE(
        uint256 amountOutNATIVE,
        uint256 amountInMax,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountIn);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountOut);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountIn);
}