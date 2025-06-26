// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./KOLSwapRouterBase.sol";
import "./interfaces/IUniversalRouter.sol";

contract KOLRouterUniswap is KOLSwapRouterBase {
    using SafeERC20 for IERC20;

    address public targetApprove;

    /**
     * @dev Constructor that initializes the KOL router instance.
     * @param _kolAddress Address of the KOL associated with this router
     * @param _dexRouter Address of the Uniswap UniversalRouter
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
     * @notice Executes a swap where the user sends NATIVE token (e.g., AVAX) as input.
     * @dev Subtracts the fixed fee from msg.value and forwards the remaining value to UniversalRouter.
     * @param commands Encoded commands for UniversalRouter
     * @param inputs Encoded inputs for each command
     * @param deadline Unix timestamp after which the swap is invalid
     */
    function executeNATIVEIn(
        bytes calldata commands,
        bytes[] calldata inputs,
        uint256 deadline
    ) external payable nonReentrant verifyFee(msg.value) {
        // Subtract the KOL fee from total msg.value
        uint256 valueToSend = msg.value - fixedFeeAmount;

        // Call Uniswap UniversalRouter with remaining value
        IUniversalRouter(dexRouter).execute{value: valueToSend}(
            commands,
            inputs,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);
    }

    /**
     * @notice Executes a swap where the user sends ERC20 token as input.
     * @dev Transfers the input tokens from the user to this contract, approves Permit2 to use them, and forwards calldata to UniversalRouter.
     * @param commands Encoded commands for UniversalRouter
     * @param inputs Encoded inputs for each command
     * @param deadline Unix timestamp after which the swap is invalid
     * @param tokenIn Address of the ERC20 token to swap from
     * @param amountIn Amount of the ERC20 token to transfer and use
     */
    function executeTokenIn(
        bytes calldata commands,
        bytes[] calldata inputs,
        uint256 deadline,
        address tokenIn,
        uint256 amountIn
    ) external payable nonReentrant verifyFee(msg.value) {
        IERC20(tokenIn).safeTransferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenIn).approve(targetApprove, amountIn);

        // Call Uniswap UniversalRouter (which will trigger Permit2 transfer)
        IUniversalRouter(dexRouter).execute(
            commands,
            inputs,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);
    }


    function setTargetApprove(address _target) public {
        targetApprove = _target;
    }


    /**
     * @notice Allows this contract to receive NATIVE tokens (e.g., AVAX)
     * @dev Used to receive refund dust from UniversalRouter, if any
     */
    receive() external payable {}
}
