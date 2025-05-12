// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./KOLSwapRouterBase.sol";
import "./interfaces/ILBRouter.sol";

/**
 * @title KOLRouterTraderJoe
 * @notice Router for KOLs that supports direct swaps via Trader Joe v1 and v2.x using ILBRouter.
 * @dev Handles both native and ERC20 swaps, applying a fixed fee in native token (e.g., AVAX).
 */
contract KOLRouterTraderJoe is KOLSwapRouterBase {
    using SafeERC20 for IERC20;

    /**
     * @dev Constructor that initializes the KOL router instance.
     * @param _kolAddress Address of the KOL associated with this router
     * @param _dexRouter Address of the Trader Joe UniversalRouter
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
     * @notice Swap exact native tokens for ERC20 tokens.
     * @dev Deducts fee and forwards the remaining native value to Trader Joe router.
     * @return amountOut The amount of tokens received from the swap.
     */
    function swapExactNATIVEForTokens(
        uint256 amountOutMin,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    )
        external
        payable
        nonReentrant
        verifyFee(msg.value)
        returns (uint256 amountOut)
    {
        uint256 valueToSend = msg.value - fixedFeeAmount;

        amountOut = ILBRouter(dexRouter).swapExactNATIVEForTokens{
            value: valueToSend
        }(amountOutMin, path, to, deadline);

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);
        return amountOut;
    }

    /**
     * @notice Swap native tokens for exact ERC20 token amount.
     * @dev Refunds leftover AVAX if overpaid.
     * @return amountsIn Array containing input amounts per swap hop.
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
        uint256 valueToSend = msg.value - fixedFeeAmount;

        amountsIn = ILBRouter(dexRouter).swapNATIVEForExactTokens{
            value: valueToSend
        }(amountOut, path, to, deadline);

        // Refund any unspent AVAX back to the user
        if (valueToSend > amountsIn[0]) {
            (bool success, ) = msg.sender.call{
                value: valueToSend - amountsIn[0]
            }("");
            require(success, "KOLSwapRouter: REFUND_TRANSFER_FAILED");
        }

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);
        return amountsIn;
    }

    /**
     * @notice Swap exact amount of ERC20 tokens for native tokens.
     * @dev Pulls tokens from user, approves DEX, and executes the swap.
     * @return amountOut The amount of native tokens received.
     */
    function swapExactTokensForNATIVE(
        uint256 amountIn,
        uint256 amountOutMinNATIVE,
        ILBRouter.Path calldata path,
        address payable to,
        uint256 deadline
    )
        external
        payable
        nonReentrant
        verifyFee(msg.value)
        returns (uint256 amountOut)
    {
        IERC20(address(path.tokenPath[0])).safeTransferFrom(
            msg.sender,
            address(this),
            amountIn
        );
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountIn);

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
     * @notice Swap up to a maximum amount of ERC20 tokens for a fixed amount of native tokens.
     * @return amountsIn Array containing input amounts per swap hop.
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
        nonReentrant
        verifyFee(msg.value)
        returns (uint256[] memory amountsIn)
    {
        IERC20(address(path.tokenPath[0])).safeTransferFrom(
            msg.sender,
            address(this),
            amountInMax
        );
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountInMax);

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
     * @notice Swap exact amount of ERC20 tokens for another ERC20 token.
     * @return amountOut The amount of destination token received.
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    )
        external
        payable
        nonReentrant
        verifyFee(msg.value)
        returns (uint256 amountOut)
    {
        IERC20(address(path.tokenPath[0])).safeTransferFrom(
            msg.sender,
            address(this),
            amountIn
        );
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountIn);

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
     * @notice Swap up to a maximum amount of ERC20 tokens to get a fixed amount of another ERC20 token.
     * @return amountsIn Array of token amounts used in the swap path.
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
        nonReentrant
        returns (uint256[] memory amountsIn)
    {
        IERC20(address(path.tokenPath[0])).safeTransferFrom(
            msg.sender,
            address(this),
            amountInMax
        );
        IERC20(address(path.tokenPath[0])).approve(dexRouter, amountInMax);

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
     * @dev Allows receiving native tokens (e.g., AVAX) in case of refund or dust from swaps.
     */
    receive() external payable {}
}
