// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./KOLSwapRouterBase.sol";
import "./interfaces/IArenaRouter01.sol";

/**
 * @title KOLRouterArenaSwap
 * @notice Router for KOLs that supports direct swaps via ArenaSwap v2 using IArenaRouter01.
 * @dev Handles both native and ERC20 swaps, applying a fixed fee in native token (e.g., AVAX).
 */
contract KOLRouterArenaSwap is KOLSwapRouterBase {
    using SafeERC20 for IERC20;

    /**
     * @dev Constructor that initializes the KOL router instance.
     * @param _kolAddress Address of the KOL associated with this router
     * @param _dexRouter Address of the ArenaSwap UniversalRouter
     * @param _factoryAddress Address of the factory that deployed this router
     * @param _sherryFoundationAddress Address of Sherry Foundation
     * @param _sherryTreasuryAddress Address of Sherry Treasury
     */
    constructor(
        address _kolAddress,
        address _dexRouter,
        address _factoryAddress,
        address _sherryFoundationAddress,
        address _sherryTreasuryAddress
    )
        KOLSwapRouterBase(
            _kolAddress,
            _dexRouter,
            _factoryAddress,
            _sherryFoundationAddress,
            _sherryTreasuryAddress
        )
    {}

    /**
     * @notice Swap exact amount of ERC20 tokens for another ERC20 token.
     * @dev Deducts 2% fee and forwards the remaining native value to Arena Swap router.
     * @return amounts The amount of destination token received.
     */
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external nonReentrant returns (uint[] memory amounts) {
        require(amountIn > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        address inputToken = address(path[0]);

        // Transfer full amount from user
        IERC20(inputToken).safeTransferFrom(
            msg.sender,
            address(this),
            amountIn
        );

        // Deduct fees
        NetAmount memory netAmountData = _deductFees(amountIn, inputToken);

        // Approve net amount for swap
        IERC20(inputToken).approve(dexRouter, netAmountData.netAmount);

        amounts = IArenaRouter01(dexRouter).swapExactTokensForTokens(
            netAmountData.netAmount,
            amountOutMin,
            path,
            to,
            deadline
        );

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            inputToken,
            address(path[path.length - 1]),
            netAmountData.netAmount,
            netAmountData.kolFee,
            netAmountData.foundationFee,
            netAmountData.treasuryFee
        );

        return amounts;
    }

    /**
     * @notice Swap up to a maximum amount of ERC20 tokens to get a fixed amount of another ERC20 token.
     * @return amounts Array of token amounts used in the swap path.
     */
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external nonReentrant returns (uint[] memory amounts) {
        require(amountInMax > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        address inputToken = address(path[0]);

        // Transfer max amount from user
        IERC20(inputToken).safeTransferFrom(
            msg.sender,
            address(this),
            amountInMax
        );

        // Deduct fees from max amount
        NetAmount memory netAmountData = _deductFees(amountInMax, inputToken);

        // Approve net amount for swap
        IERC20(inputToken).approve(dexRouter, netAmountData.netAmount);

        amounts = IArenaRouter01(dexRouter).swapTokensForExactTokens(
            amountOut,
            netAmountData.netAmount,
            path,
            to,
            deadline
        );

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            inputToken,
            address(path[path.length - 1]),
            amounts[0],
            netAmountData.kolFee,
            netAmountData.foundationFee,
            netAmountData.treasuryFee
        );

        return amounts;
    }

    /**
     * @notice Swap exact native tokens for ERC20 tokens.
     * @dev Deducts fee and forwards the remaining native value to ArenaSwap router.
     * @return amounts The amount of tokens received from the swap.
     */
    function swapExactAVAXForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable nonReentrant returns (uint[] memory amounts) {
        require(msg.value > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        NetAmount memory netAmountData = _deductFees(msg.value, address(0));

        amounts = IArenaRouter01(dexRouter).swapExactAVAXForTokens{
            value: netAmountData.netAmount
        }(amountOutMin, path, to, deadline);

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            address(0),
            address(path[path.length - 1]),
            netAmountData.netAmount,
            netAmountData.kolFee,
            netAmountData.foundationFee,
            netAmountData.treasuryFee
        );

        return amounts;
    }

    /**
     * @notice Swap up to a maximum amount of ERC20 tokens for a fixed amount of native tokens.
     * @return amounts Array containing input amounts per swap hop.
     */
    function swapTokensForExactAVAX(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts) {
        require(amountInMax > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        address inputToken = address(path[0]);

        // Transfer max amount from user
        IERC20(inputToken).safeTransferFrom(
            msg.sender,
            address(this),
            amountInMax
        );

        // Calculate net amount after fees
        NetAmount memory netAmountData = _deductFees(amountInMax, inputToken);

        // Approve the net amount for the swap
        IERC20(inputToken).approve(dexRouter, netAmountData.netAmount);

        amounts = IArenaRouter01(dexRouter).swapTokensForExactAVAX(
            amountOut,
            netAmountData.netAmount,
            path,
            to,
            deadline
        );

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            inputToken,
            address(path[path.length - 1]),
            amounts[0],
            netAmountData.kolFee,
            netAmountData.foundationFee,
            netAmountData.treasuryFee
        );

        return amounts;
    }

    /**
     * @notice Swap exact amount of ERC20 tokens for native tokens.
     * @dev Pulls tokens from user, approves DEX, and executes the swap.
     * @return amounts The amount of native tokens received.
     */
    function swapExactTokensForAVAX(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external nonReentrant returns (uint[] memory amounts) {
        require(amountIn > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        address inputToken = address(path[0]);

        // Transfer full amount from user
        IERC20(inputToken).safeTransferFrom(
            msg.sender,
            address(this),
            amountIn
        );

        // Deduct fees from the transferred amount
        NetAmount memory netAmountData = _deductFees(amountIn, inputToken);

        // Approve only the net amount for the swap
        IERC20(inputToken).approve(dexRouter, netAmountData.netAmount);

        amounts = IArenaRouter01(dexRouter).swapExactTokensForAVAX(
            netAmountData.netAmount,
            amountOutMin,
            path,
            to,
            deadline
        );

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            inputToken,
            address(path[path.length - 1]),
            netAmountData.netAmount,
            netAmountData.kolFee,
            netAmountData.foundationFee,
            netAmountData.treasuryFee
        );

        return amounts;
    }

    /**
     * @notice Swap native tokens for exact ERC20 token amount.
     * @dev Refunds leftover AVAX if overpaid.
     * @return amounts Array containing input amounts per swap hop.
     */
    function swapAVAXForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable nonReentrant returns (uint[] memory amounts) {
        require(msg.value > 0, "KOLSwapRouter: INVALID_INPUT_AMOUNT");

        NetAmount memory netAmountData = _deductFees(msg.value, address(0));

        amounts = IArenaRouter01(dexRouter).swapAVAXForExactTokens{
            value: netAmountData.netAmount
        }(amountOut, path, to, deadline);

        // Refund any unspent AVAX back to the user (after fees)
        if (netAmountData.netAmount > amounts[0]) {
            (bool success, ) = msg.sender.call{
                value: netAmountData.netAmount - amounts[0]
            }("");
            require(success, "KOLSwapRouter: REFUND_TRANSFER_FAILED");
        }

        emit SwapExecuted(
            kolAddress,
            msg.sender,
            address(0),
            address(path[path.length - 1]),
            amounts[0],
            netAmountData.kolFee,
            netAmountData.foundationFee,
            netAmountData.treasuryFee
        );

        return amounts;
    }

    /**
     * @dev Allows receiving native tokens (e.g., AVAX) in case of refund or dust from swaps.
     */
    receive() external payable {}
}
