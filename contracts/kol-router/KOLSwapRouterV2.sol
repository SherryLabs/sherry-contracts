// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./KOLSwapRouterBase.sol";
import "./interfaces/ILBRouter.sol";

/**
 * @title KOLSwapRouterV2
 * @dev Router for KOLs that supports Trader Joe V2.x with direct interface calls
 */
contract KOLSwapRouterV2 is KOLSwapRouterBase {
    using SafeERC20 for IERC20;

    /**
     * @dev Constructor
     * @param _kolAddress Address of the KOL
     * @param _dexRouter Address of the DEX router
     * @param _factoryAddress Address of the factory
     */
    constructor(
        address _kolAddress,
        address _dexRouter,
        address _factoryAddress
    ) KOLSwapRouterBase(_kolAddress, _dexRouter, "V2", _factoryAddress) {}

    /**
     * @dev Exact NATIVE for tokens swap
     */
    function swapExactNATIVEForTokens(
        uint256 amountOutMin,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable verifyFee(msg.value) returns (uint256 amountOut) {
        uint256 valueToSend = msg.value - fixedFeeAmount;

        // Call the DEX using direct interface call
        amountOut = ILBRouter(dexRouter).swapExactNATIVEForTokens{
            value: valueToSend
        }(
            amountOutMin,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amountOut;
    }

    /**
     * @dev NATIVE for exact tokens swap
     */
    function swapNATIVEForExactTokens(
        uint256 amountOut,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    )
        external
        payable
        verifyFee(msg.value)
        nonReentrant
        returns (uint256[] memory amountsIn)
    {
        // Value to send to the DEX
        uint256 valueToSend = msg.value - fixedFeeAmount;

        // Call the DEX using direct interface call
        amountsIn = ILBRouter(dexRouter).swapNATIVEForExactTokens{
            value: valueToSend
        }(
            amountOut,
            path,
            to,
            deadline
        );

        // Refund if necessary
        if (valueToSend > amountsIn[0]) {
            (bool success, ) = msg.sender.call{
                value: valueToSend - amountsIn[0]
            }(
                new bytes(0)
            );
            require(success, "KOLSwapRouter: REFUND_TRANSFER_FAILED");
        }

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amountsIn;
    }

    /**
     * @dev Exact tokens for NATIVE swap
     */
    function swapExactTokensForNATIVE(
        uint256 amountIn,
        uint256 amountOutMinNATIVE,
        ILBRouter.Path calldata path,
        address payable to,
        uint256 deadline
    ) external payable verifyFee(msg.value) returns (uint256 amountOut) {
        // Transfer tokens from user to contract
        IERC20(address(path.tokenPath[0])).safeTransferFrom(
            msg.sender,
            address(this), amountIn
        );
        // Approve tokens to the DEX router
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountIn);

        // Call the DEX using direct interface call
        amountOut = ILBRouter(dexRouter).swapExactTokensForNATIVE(
            amountIn,
            amountOutMinNATIVE,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amountOut;
    }

    /**
     * @dev Tokens for exact NATIVE swap
     */
    function swapTokensForExactNATIVE(
        uint256 amountOutNATIVE,
        uint256 amountInMax,
        ILBRouter.Path calldata path,
        address payable to,
        uint256 deadline
    )
        external
        payable
        verifyFee(msg.value)
        returns (uint256[] memory amountsIn)
    {
        // Transfer tokens from user to contract
        IERC20(address(path.tokenPath[0])).safeTransferFrom(
            msg.sender,
            address(this), amountInMax
        );
        // Approve tokens to the DEX router
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountInMax);

        // Call the DEX using direct interface call
        amountsIn = ILBRouter(dexRouter).swapTokensForExactNATIVE(
            amountOutNATIVE,
            amountInMax,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amountsIn;
    }

    /**
     * @dev Exact tokens for tokens swap
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable verifyFee(msg.value) returns (uint256 amountOut) {
        // Transfer tokens from user to contract
        IERC20(address(path.tokenPath[0])).safeTransferFrom(
            msg.sender,
            address(this), amountIn
        );
        // Approve tokens to the DEX router
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountIn);

        // Call the DEX using direct interface call
        amountOut = ILBRouter(dexRouter).swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amountOut;
    }

    /**
     * @dev Tokens for exact tokens swap
     */
    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    )
        external
        payable
        verifyFee(msg.value)
        returns (uint256[] memory amountsIn)
    {
        // Transfer tokens from user to contract
        IERC20(address(path.tokenPath[0])).safeTransferFrom(
            msg.sender,
            address(this), amountInMax
        );
        // Approve tokens to the DEX router
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountInMax);

        // Call the DEX using direct interface call
        amountsIn = ILBRouter(dexRouter).swapTokensForExactTokens(
            amountOut,
            amountInMax,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amountsIn;
    }

    /**
    * @dev Receives NATIVE from possible refund dust native, if any
    */
    receive() external payable {}
}