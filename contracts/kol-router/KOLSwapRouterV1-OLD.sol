// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./KOLSwapRouterBase.sol";
import "./IKOLSwapRouterV1.sol";

/**
 * @title KOLSwapRouterV1
 * @dev Router for KOLs that supports Trader Joe V1
 */
contract KOLSwapRouterV1 is KOLSwapRouterBase, IKOLSwapRouterV1 {
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
    ) external payable override returns (uint[] memory amounts) {
        // Verify the required fee
        _verifyFee(msg.value);
        
        // Update accumulated fee
        _addFee(fixedFeeAmount);
        
        // Calculate value to send
        uint256 valueToSend = msg.value - fixedFeeAmount;
        
        // Call the DEX directly
        (bool success, bytes memory returnData) = dexRouter.call{value: valueToSend}(
            abi.encodeWithSignature(
                "swapExactAVAXForTokens(uint256,address[],address,uint256)",
                amountOutMin,
                path,
                to,
                deadline
            )
        );
        require(success, "KOLSwapRouter: SWAP_FAILED");
        
        // Decode result - using a safer approach for older EVM versions
        amounts = abi.decode(returnData, (uint256[]));
        
        // Emit event
        emit SwapExecuted(msg.sender, msg.value, fixedFeeAmount);
        
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
    ) external payable override returns (uint[] memory amounts) {
        // Verify the required fee
        _verifyFee(msg.value);
        
        // Update accumulated fee
        _addFee(fixedFeeAmount);
        
        // Calculate value to send
        uint256 valueToSend = msg.value - fixedFeeAmount;
        
        // Get balance before the swap
        uint256 balanceBefore = address(this).balance;
        
        // Call the DEX
        (bool success, bytes memory returnData) = dexRouter.call{value: valueToSend}(
            abi.encodeWithSignature(
                "swapAVAXForExactTokens(uint256,address[],address,uint256)",
                amountOut,
                path,
                to,
                deadline
            )
        );
        require(success, "KOLSwapRouter: SWAP_FAILED");
        
        // Decode the result
        amounts = abi.decode(returnData, (uint256[]));
        
        // Get balance after the swap to determine the refund
        uint256 balanceAfter = address(this).balance;
        
        // If there's a balance increase, it means we got a refund
        if (balanceAfter > balanceBefore - valueToSend + fixedFeeAmount) {
            // Calculate the refund amount
            uint256 refundAmount = balanceAfter - (balanceBefore - valueToSend + fixedFeeAmount);
            
            // Send the refund to the original user
            (bool refundSuccess, ) = msg.sender.call{value: refundAmount}("");
            require(refundSuccess, "KOLSwapRouter: REFUND_FAILED");
        }
        
        // Emit event - we use amounts[0] as the actual AVAX amount used
        emit SwapExecuted(msg.sender, amounts[0], fixedFeeAmount);
        
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
    ) external payable override returns (uint[] memory amounts) {
        // Verify that the fee was sent
        _verifyFee(msg.value);
        
        // Update accumulated fee
        _addFee(fixedFeeAmount);
        
        // Transfer tokens from user to contract
        IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn);
        
        // Approve the DEX router to spend the tokens
        IERC20(path[0]).approve(dexRouter, amountIn);
        
        // Call the DEX directly
        (bool success, bytes memory returnData) = dexRouter.call(
            abi.encodeWithSignature(
                "swapExactTokensForAVAX(uint256,uint256,address[],address,uint256)",
                amountIn,
                amountOutMin,
                path,
                to,
                deadline
            )
        );
        require(success, "KOLSwapRouter: SWAP_FAILED");
        
        // Decode result - using a safer approach for older EVM versions
        amounts = abi.decode(returnData, (uint256[]));
           
        // Emit event
        emit SwapExecuted(msg.sender, amountIn, fixedFeeAmount);
        
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
    ) external payable override returns (uint[] memory amounts) {
        // Verify that the fee was sent
        _verifyFee(msg.value);
        
        // Update accumulated fee
        _addFee(fixedFeeAmount);
        
        // Transfer tokens from user to contract
        IERC20(path[0]).transferFrom(msg.sender, address(this), amountInMax);
        
        // Approve the DEX router to spend the tokens
        IERC20(path[0]).approve(dexRouter, amountInMax);
        
        // Call the DEX directly
        (bool success, bytes memory returnData) = dexRouter.call(
            abi.encodeWithSignature(
                "swapTokensForExactAVAX(uint256,uint256,address[],address,uint256)",
                amountOut,
                amountInMax,
                path,
                to,
                deadline
            )
        );
        require(success, "KOLSwapRouter: SWAP_FAILED");
        
        // Decode result - using a safer approach for older EVM versions
        amounts = abi.decode(returnData, (uint256[]));
               
        // Emit event
        emit SwapExecuted(msg.sender, amountInMax, fixedFeeAmount);
        
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
    ) external payable override returns (uint[] memory amounts) {
        // Verify that the fee was sent
        _verifyFee(msg.value);
        
        // Update accumulated fee
        _addFee(fixedFeeAmount);
        
        // Transfer tokens from user to contract
        IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn);
        
        // Approve the DEX router to spend the tokens
        IERC20(path[0]).approve(dexRouter, amountIn);
        
        // Call the DEX directly
        (bool success, bytes memory returnData) = dexRouter.call(
            abi.encodeWithSignature(
                "swapExactTokensForTokens(uint256,uint256,address[],address,uint256)",
                amountIn,
                amountOutMin,
                path,
                to,
                deadline
            )
        );
        require(success, "KOLSwapRouter: SWAP_FAILED");
        
        // Decode result - using a safer approach for older EVM versions
        amounts = abi.decode(returnData, (uint256[]));
        
        // Emit event
        emit SwapExecuted(msg.sender, amountIn, fixedFeeAmount);
        
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
    ) external payable override returns (uint[] memory amounts) {
        // Verify that the fee was sent
        _verifyFee(msg.value);
        
        // Update accumulated fee
        _addFee(fixedFeeAmount);
        
        // Transfer tokens from user to contract
        IERC20(path[0]).transferFrom(msg.sender, address(this), amountInMax);
        
        // Approve the DEX router to spend the tokens
        IERC20(path[0]).approve(dexRouter, amountInMax);
        
        // Call the DEX directly
        (bool success, bytes memory returnData) = dexRouter.call(
            abi.encodeWithSignature(
                "swapTokensForExactTokens(uint256,uint256,address[],address,uint256)",
                amountOut,
                amountInMax,
                path,
                to,
                deadline
            )
        );
        require(success, "KOLSwapRouter: SWAP_FAILED");
        
        // Decode result - using a safer approach for older EVM versions
        amounts = abi.decode(returnData, (uint256[]));
            
        // Emit event
        emit SwapExecuted(msg.sender, amountInMax, fixedFeeAmount);
        
        return amounts;
    }
}