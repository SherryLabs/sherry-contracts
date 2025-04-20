// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./KOLSwapRouterBase.sol";
import "./IKOLSwapRouterV2.sol";
import "./ILBRouter.sol";

/**
 * @title KOLSwapRouterV2
 * @dev Router for KOLs that supports Trader Joe V2.x
 */
contract KOLSwapRouterV2 is KOLSwapRouterBase, IKOLSwapRouterV2 {
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
     * @dev Exact AVAX for tokens swap
     */
    function swapExactNATIVEForTokens(
        uint256 amountOutMin,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable override returns (uint256 amountOut) {
        _verifyFee(msg.value);
        _addFee(fixedFeeAmount);

        // Value to send to the DEX
        uint256 valueToSend = msg.value - fixedFeeAmount;

        // Call the DEX
        (bool success, bytes memory result) = dexRouter.call{value: valueToSend}(
            abi.encodeWithSelector(
                ILBRouter.swapExactNATIVEForTokens.selector,
                amountOutMin,
                path,
                to,
                deadline
            )
        );
        require(success, "DEX call failed");

        emit SwapExecuted(msg.sender, msg.value, fixedFeeAmount);

        return abi.decode(result, (uint256));
    }

    /**
     * @dev AVAX for exact tokens swap
     */
    function swapNATIVEForExactTokens(
        uint256 amountOut,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable override returns (uint256 amountIn) {
        _verifyFee(msg.value);
        _addFee(fixedFeeAmount);

        // Value to send to the DEX
        uint256 valueToSend = msg.value - fixedFeeAmount;

        // Call the DEX
        (bool success, bytes memory result) = dexRouter.call{value: valueToSend}(
            abi.encodeWithSelector(
                ILBRouter.swapNATIVEForExactTokens.selector,
                amountOut,
                path,
                to,
                deadline
            )
        );
        require(success, "DEX call failed");

        // Decode the result
        uint256 amountUsed = abi.decode(result, (uint256));

        // If less AVAX was used than sent, refund the difference
        if (valueToSend > amountUsed) {
            uint256 refundAmount = valueToSend - amountUsed;
            (bool refundSuccess, ) = msg.sender.call{value: refundAmount}("");
            require(refundSuccess, "Refund failed");
        }

        // Emit event
        emit SwapExecuted(msg.sender, amountUsed, fixedFeeAmount);

        return amountUsed;
    }

    /**
     * @dev Exact tokens for NATIVE swap
     */
    function swapExactTokensForNATIVE(
        uint256 amountIn,
        uint256 amountOutMinNATIVE,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable override returns (uint256 amountOut) {
        // Verify that the fee was sent
        _verifyFee(msg.value);

        // Update accumulated fee
        _addFee(fixedFeeAmount);

        // Transfer tokens from user to contract
        IERC20(address(path.tokenPath[0])).transferFrom(msg.sender, address(this), amountIn);

        // Approve tokens to the DEX router
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountIn);

        // Call the DEX
        (bool success, bytes memory result) = dexRouter.call(
            abi.encodeWithSelector(
                ILBRouter.swapExactTokensForNATIVE.selector,
                amountIn,
                amountOutMinNATIVE,
                path,
                address(this), // Receive AVAX in this contract first
                deadline
            )
        );
        require(success, "DEX call failed");

        // Decode the result
        uint256 receivedAmount = abi.decode(result, (uint256));

        // Transfer AVAX to the original recipient
        (bool transferSuccess, ) = to.call{value: receivedAmount}("");
        require(transferSuccess, "AVAX transfer failed");

        // Emit event
        emit SwapExecuted(msg.sender, amountIn, fixedFeeAmount);

        return receivedAmount;
    }

    /**
     * @dev Tokens for exact NATIVE swap
     */
    function swapTokensForExactNATIVE(
        uint256 amountOutNATIVE,
        uint256 amountInMax,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable override returns (uint256 amountIn) {
        // Verify that the fee was sent
        _verifyFee(msg.value);

        // Update accumulated fee
        _addFee(fixedFeeAmount);

        // Transfer tokens from user to contract
        IERC20(address(path.tokenPath[0])).transferFrom(msg.sender, address(this), amountInMax);

        // Approve tokens to the DEX router
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountInMax);

        // Call the DEX
        (bool success, bytes memory result) = dexRouter.call(
            abi.encodeWithSelector(
                ILBRouter.swapTokensForExactNATIVE.selector,
                amountOutNATIVE,
                amountInMax,
                path,
                address(this), // Receive AVAX in this contract first
                deadline
            )
        );
        require(success, "DEX call failed");

        // Decode the result
        uint256 amountUsed = abi.decode(result, (uint256));

        // Return unused tokens if necessary
        if (amountInMax > amountUsed) {
            IERC20(address(path.tokenPath[0])).transfer(msg.sender, amountInMax - amountUsed);
        }

        // Transfer AVAX to the original recipient
        (bool transferSuccess, ) = to.call{value: amountOutNATIVE}("");
        require(transferSuccess, "AVAX transfer failed");

        // Emit event
        emit SwapExecuted(msg.sender, amountUsed, fixedFeeAmount);

        return amountUsed;
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
    ) external payable override returns (uint256 amountOut) {
        // Verify that the fee was sent
        _verifyFee(msg.value);

        // Update accumulated fee
        _addFee(fixedFeeAmount);

        // Transfer tokens from user to contract
        IERC20(address(path.tokenPath[0])).transferFrom(msg.sender, address(this), amountIn);

        // Approve tokens to the DEX router
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountIn);

        // Call the DEX
        (bool success, bytes memory result) = dexRouter.call(
            abi.encodeWithSelector(
                ILBRouter.swapExactTokensForTokens.selector,
                amountIn,
                amountOutMin,
                path,
                to,
                deadline
            )
        );
        require(success, "DEX call failed");

        // Decode the result
        uint256 receivedAmount = abi.decode(result, (uint256));

        // Emit event
        emit SwapExecuted(msg.sender, amountIn, fixedFeeAmount);

        return receivedAmount;
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
    ) external payable override returns (uint256 amountIn) {
        // Verify that the fee was sent
        _verifyFee(msg.value);

        // Update accumulated fee
        _addFee(fixedFeeAmount);

        // Transfer tokens from user to contract
        IERC20(address(path.tokenPath[0])).transferFrom(msg.sender, address(this), amountInMax);

        // Approve tokens to the DEX router
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountInMax);

        // Call the DEX
        (bool success, bytes memory result) = dexRouter.call(
            abi.encodeWithSelector(
                ILBRouter.swapTokensForExactTokens.selector,
                amountOut,
                amountInMax,
                path,
                to,
                deadline
            )
        );
        require(success, "DEX call failed");

        // Decode the result
        uint256 amountUsed = abi.decode(result, (uint256));

        // Return unused tokens if necessary
        if (amountInMax > amountUsed) {
            IERC20(address(path.tokenPath[0])).transfer(msg.sender, amountInMax - amountUsed);
        }

        // Emit event
        emit SwapExecuted(msg.sender, amountUsed, fixedFeeAmount);

        return amountUsed;
    }
}