// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./KOLSwapRouterBase.sol";
import "./interfaces/ILBRouter.sol";

/**
 * @title KOLRouterTraderJoe
 * @notice Router for KOLs that supports direct swaps via Trader Joe v1 and v2.x using ILBRouter.
 * @dev Handles both native and ERC20 swaps, applying a 2% fee split between KOL and Foundation.
 */
contract KOLRouterTraderJoe is KOLSwapRouterBase {
    using SafeERC20 for IERC20;

    /**
     * @dev Constructor that initializes the KOL router instance.
     * @param _kolAddress Address of the KOL associated with this router
     * @param _dexRouter Address of the Trader Joe UniversalRouter
     * @param _factoryAddress Address of the factory that deployed this router
     * @param _sherryFoundationAddress Address of Sherry Foundation
     */
    constructor(
        address _kolAddress,
        address _dexRouter,
        address _factoryAddress,
        address _sherryFoundationAddress
    )
        KOLSwapRouterBase(
            _kolAddress,
            _dexRouter,
            _factoryAddress,
            _sherryFoundationAddress
        )
    {}

    /**
     * @notice Swap exact native tokens for ERC20 tokens.
     * @dev Deducts 2% fee and forwards the remaining native value to Trader Joe router.
     * @return amountOut The amount of tokens received from the swap.
     */
    function swapExactNATIVEForTokens(
        uint256 amountOutMin,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable nonReentrant returns (uint256 amountOut) {
        require(msg.value > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        uint256[3] memory netAmount = _deductFees(msg.value, address(0));

        amountOut = ILBRouter(dexRouter).swapExactNATIVEForTokens{
            value: netAmount[0]
        }(amountOutMin, path, to, deadline);

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            address(0),
            netAmount[1],
            netAmount[2]
        );

        return amountOut;
    }

    /**
     * @notice Swap native tokens for exact ERC20 token amount.
     * @dev Deducts fees and refunds leftover AVAX if overpaid.
     * @return amountsIn Array containing input amounts per swap hop.
     */
    function swapNATIVEForExactTokens(
        uint256 amountOut,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable nonReentrant returns (uint256[] memory amountsIn) {
        require(msg.value > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        uint256[3] memory netAmount = _deductFees(msg.value, address(0));

        amountsIn = ILBRouter(dexRouter).swapNATIVEForExactTokens{
            value: netAmount[0]
        }(amountOut, path, to, deadline);

        // Refund any unspent AVAX back to the user (after fees)
        if (netAmount[0] > amountsIn[0]) {
            (bool success, ) = msg.sender.call{
                value: netAmount[0] - amountsIn[0]
            }("");
            require(success, "KOLSwapRouter: REFUND_TRANSFER_FAILED");
        }

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            address(0),
            netAmount[1],
            netAmount[2]
        );

        return amountsIn;
    }

    /**
     * @notice Swap exact amount of ERC20 tokens for native tokens.
     * @dev Pulls tokens from user, deducts fees, approves DEX, and executes the swap.
     * @return amountOut The amount of native tokens received.
     */
    function swapExactTokensForNATIVE(
        uint256 amountIn,
        uint256 amountOutMinNATIVE,
        ILBRouter.Path calldata path,
        address payable to,
        uint256 deadline
    ) external nonReentrant returns (uint256 amountOut) {
        require(amountIn > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        address inputToken = address(path.tokenPath[0]);

        // Transfer full amount from user
        IERC20(inputToken).safeTransferFrom(
            msg.sender,
            address(this),
            amountIn
        );

        // Deduct fees from the transferred amount
        uint256[3] memory netAmount = _deductFees(amountIn, inputToken);

        // Approve only the net amount for the swap
        IERC20(inputToken).approve(dexRouter, netAmount[0]);

        amountOut = ILBRouter(dexRouter).swapExactTokensForNATIVE(
            netAmount[0],
            amountOutMinNATIVE,
            path,
            to,
            deadline
        );

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            inputToken,
            netAmount[1],
            netAmount[2]
        );

        return amountOut;
    }

    /**
     * @notice Swap up to a maximum amount of ERC20 tokens for a fixed amount of native tokens.
     * @return amountsIn Array containing input amounts per swap hop.
     */
    function swapTokensForExactNATIVE(
        uint256 amountOutNATIVE,
        uint256 amountInMax,
        ILBRouter.Path calldata path,
        address payable to,
        uint256 deadline
    ) external nonReentrant returns (uint256[] memory amountsIn) {
        require(amountInMax > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        address inputToken = address(path.tokenPath[0]);

        // Transfer max amount from user
        IERC20(inputToken).safeTransferFrom(
            msg.sender,
            address(this),
            amountInMax
        );

        // Calculate net amount after fees
        uint256[3] memory netAmount = _deductFees(amountInMax, inputToken);

        // Approve the net amount for the swap
        IERC20(inputToken).approve(dexRouter, netAmount[0]);

        amountsIn = ILBRouter(dexRouter).swapTokensForExactNATIVE(
            amountOutNATIVE,
            netAmount[0],
            path,
            to,
            deadline
        );

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            inputToken,
            netAmount[1],
            netAmount[2]
        );

        return amountsIn;
    }

    /**
     * @notice Swap exact amount of ERC20 tokens for another ERC20 token.
     * @return amountOut The amount of destination token received.
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external nonReentrant returns (uint256 amountOut) {
        require(amountIn > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        address inputToken = address(path.tokenPath[0]);

        // Transfer full amount from user
        IERC20(inputToken).safeTransferFrom(
            msg.sender,
            address(this),
            amountIn
        );

        // Deduct fees
        uint256[3] memory netAmount = _deductFees(amountIn, inputToken);

        // Approve net amount for swap
        IERC20(inputToken).approve(dexRouter, netAmount[0]);

        amountOut = ILBRouter(dexRouter).swapExactTokensForTokens(
            netAmount[0],
            amountOutMin,
            path,
            to,
            deadline
        );

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            inputToken,
            netAmount[1],
            netAmount[2]
        );

        return amountOut;
    }

    /**
     * @notice Swap up to a maximum amount of ERC20 tokens to get a fixed amount of another ERC20 token.
     * @return amountsIn Array of token amounts used in the swap path.
     */
    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external nonReentrant returns (uint256[] memory amountsIn) {
        require(amountInMax > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        address inputToken = address(path.tokenPath[0]);

        // Transfer max amount from user
        IERC20(inputToken).safeTransferFrom(
            msg.sender,
            address(this),
            amountInMax
        );

        // Deduct fees from max amount
        uint256[3] memory netAmount = _deductFees(amountInMax, inputToken);

        // Approve net amount for swap
        IERC20(inputToken).approve(dexRouter, netAmount[0]);

        amountsIn = ILBRouter(dexRouter).swapTokensForExactTokens(
            amountOut,
            netAmount[0],
            path,
            to,
            deadline
        );

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            inputToken,
            netAmount[1],
            netAmount[2]
        );

        return amountsIn;
    }

    /**
     * @dev Allows receiving native tokens (e.g., AVAX) in case of refund or dust from swaps.
     */
    receive() external payable {}
}
