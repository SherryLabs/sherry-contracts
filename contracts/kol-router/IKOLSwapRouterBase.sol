// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/**
 * @title IKOLSwapRouterBase
 * @dev Base interface for all KOL routers
 */
interface IKOLSwapRouterBase {
    // Events
    event SwapExecuted(address indexed user, uint256 amountIn, uint256 feeCollected);
    event FeeUpdated(uint256 oldFee, uint256 newFee);
    event FeesWithdrawn(uint256 amount, address recipient);

    // Functions
    function updateFixedFee(uint256 _fixedFeeAmount) external;
    function withdrawFees() external;
    function getAccumulatedFees() external view returns (uint256);
    function kolAddress() external view returns (address);
    function fixedFeeAmount() external view returns (uint256);
    function dexRouter() external view returns (address);
    function routerVersion() external view returns (string memory);
}