// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./KOLSwapRouterBase.sol";
import "./interfaces/IJoeRouter02.sol";

/**
 * @title KOLSwapRouterV1
 * @dev Router for KOLs that supports Trader Joe V1 with direct interface calls
 */
contract KOLSwapRouterV1 is KOLSwapRouterBase {
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
    ) KOLSwapRouterBase(_kolAddress, _dexRouter, "V1", _factoryAddress) {}

    /**
     * @dev Exact AVAX for tokens swap
     */
    function swapExactAVAXForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    )
        external
        payable
        verifyFee(msg.value)
        returns (uint[] memory amounts)
    {
        // Calculate value to send
        uint256 valueToSend = msg.value - fixedFeeAmount;

        amounts = IJoeRouter02(dexRouter).swapExactAVAXForTokens{
            value: valueToSend
        }(
            amountOutMin,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amounts;
    }

    /**
    * @dev AVAX for exact tokens swap
    */
    function swapAVAXForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    )
        external
        payable
        nonReentrant
        verifyFee(msg.value)
        returns (uint[] memory amounts)
    {
        // Calculate value to send
        uint256 valueToSend = msg.value - fixedFeeAmount;

        amounts = IJoeRouter02(dexRouter).swapAVAXForExactTokens{
            value: valueToSend
        }(
            amountOut,
            path,
            to,
            deadline
        );

        // Refund if necessary
        if (valueToSend > amounts[0]) {
            (bool success, ) = msg.sender.call{
                value: valueToSend - amounts[0]
            }(
                new bytes(0)
            );
            require(success, "KOLSwapRouter: AVAX_TRANSFER_FAILED");
        }

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amounts;
    }

    /**
     * @dev Exact tokens for AVAX swap
     */
    function swapExactTokensForAVAX(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    )
        external
        payable
        verifyFee(msg.value)
        returns (uint[] memory amounts)
    {
        // Transfer tokens from user to contract
        IERC20(path[0]).safeTransferFrom(msg.sender, address(this), amountIn);
        // Approve the DEX router to spend the tokens
        IERC20(path[0]).approve(dexRouter, amountIn);

        amounts = IJoeRouter02(dexRouter).swapExactTokensForAVAX(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amounts;
    }

    /**
     * @dev Tokens for exact AVAX swap
     */
    function swapTokensForExactAVAX(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    )
        external
        payable
        verifyFee(msg.value)
        returns (uint[] memory amounts)
    {
        // Transfer tokens from user to contract
        IERC20(path[0]).safeTransferFrom(
            msg.sender,
            address(this), amountInMax
        );
        // Approve the DEX router to spend the tokens
        IERC20(path[0]).approve(dexRouter, amountInMax);

        amounts = IJoeRouter02(dexRouter).swapTokensForExactAVAX(
            amountOut,
            amountInMax,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amounts;
    }

    /**
     * @dev Exact tokens for tokens swap
     */
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    )
        external
        payable
        verifyFee(msg.value)
        returns (uint[] memory amounts)
    {
        // Transfer tokens from user to contract using SafeERC20
        IERC20(path[0]).safeTransferFrom(msg.sender, address(this), amountIn);
        // Approve the DEX router to spend the tokens
        IERC20(path[0]).approve(dexRouter, amountIn);

        amounts = IJoeRouter02(dexRouter).swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amounts;
    }

    /**
     * @dev Tokens for exact tokens swap
     */
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    )
        external
        payable
        verifyFee(msg.value)
        returns (uint[] memory amounts)
    {
        // Transfer tokens from user to contract
        IERC20(path[0]).safeTransferFrom(
            msg.sender,
            address(this), amountInMax
        );
        // Approve the DEX router to spend the tokens
        IERC20(path[0]).approve(dexRouter, amountInMax);

        // Call the DEX directly through interface
        amounts = IJoeRouter02(dexRouter).swapTokensForExactTokens(
            amountOut,
            amountInMax,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);

        return amounts;
    }

    /**
    * @dev Receives AVAX from possible refund dust avax, if any
    */
    receive() external payable {}
}