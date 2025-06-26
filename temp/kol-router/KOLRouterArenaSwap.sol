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
     * @param _fixedFeeAmount Amount to be subtracted as Fee
     */
    constructor(
        address _kolAddress,
        address _dexRouter,
        address _factoryAddress,
        uint256 _fixedFeeAmount
    )
        KOLSwapRouterBase(
            _kolAddress,
            _dexRouter,
            _factoryAddress,
            _fixedFeeAmount
        )
    {}

    /**
     * @notice Swap exact amount of ERC20 tokens for another ERC20 token.
     * @return amounts The amount of destination token received.
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
        nonReentrant
        verifyFee(msg.value)
        returns (uint[] memory amounts)
    {
        IERC20(address(path[0])).safeTransferFrom(
            msg.sender,
            address(this),
            amountIn
        );
        IERC20(address(path[0])).approve(dexRouter, amountIn);

        amounts = IArenaRouter01(dexRouter).swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);
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
    )
        external
        payable
        verifyFee(msg.value)
        nonReentrant
        returns (uint[] memory amounts)
    {
        IERC20(address(path[0])).safeTransferFrom(
            msg.sender,
            address(this),
            amountInMax
        );
        IERC20(address(path[0])).approve(dexRouter, amountInMax);

        amounts = IArenaRouter01(dexRouter).swapTokensForExactTokens(
            amountOut,
            amountInMax,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);
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
    )
        external
        payable
        nonReentrant
        verifyFee(msg.value)
        returns (uint[] memory amounts)
    {
        uint256 valueToSend = msg.value - fixedFeeAmount;

        amounts = IArenaRouter01(dexRouter).swapExactAVAXForTokens{
            value: valueToSend
        }(amountOutMin, path, to, deadline);

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);
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
        IERC20(address(path[0])).safeTransferFrom(
            msg.sender,
            address(this),
            amountInMax
        );
        IERC20(address(path[0])).approve(dexRouter, amountInMax);

        amounts = IArenaRouter01(dexRouter).swapTokensForExactAVAX(
            amountOut,
            amountInMax,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);
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
    )
        external
        payable
        nonReentrant
        verifyFee(msg.value)
        returns (uint[] memory amounts)
    {
        IERC20(address(path[0])).safeTransferFrom(
            msg.sender,
            address(this),
            amountIn
        );
        IERC20(address(path[0])).approve(dexRouter, amountIn);

        amounts = IArenaRouter01(dexRouter).swapExactTokensForAVAX(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);
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
    )
        external
        payable
        verifyFee(msg.value)
        nonReentrant
        returns (uint[] memory amounts)
    {
        uint256 valueToSend = msg.value - fixedFeeAmount;

        amounts = IArenaRouter01(dexRouter).swapAVAXForExactTokens{
            value: valueToSend
        }(amountOut, path, to, deadline);

        // Refund any unspent AVAX back to the user
        if (valueToSend > amounts[0]) {
            (bool success, ) = msg.sender.call{value: valueToSend - amounts[0]}(
                ""
            );
            require(success, "KOLSwapRouter: REFUND_TRANSFER_FAILED");
        }

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);
    }

    /**
     * @dev Allows receiving native tokens (e.g., AVAX) in case of refund or dust from swaps.
     */
    receive() external payable {}
}
