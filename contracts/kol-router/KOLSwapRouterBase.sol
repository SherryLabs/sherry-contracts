// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./IKOLSwapRouterBase.sol";

/**
 * @title KOLSwapRouterBase
 * @dev Abstract base contract for KOL routers
 */
abstract contract KOLSwapRouterBase is IKOLSwapRouterBase, ReentrancyGuard {
    using Address for address;

    // Important addresses
    address public override kolAddress;
    address public factoryAddress;
    address public override dexRouter;
    string public override routerVersion;

    // Fixed fee configurable by the KOL (in wei)
    uint256 public override fixedFeeAmount;

    // Fee accumulator
    uint256 private accumulatedFees;

    // Modifier to restrict access to KOL only
    modifier onlyKOL() {
        require(msg.sender == kolAddress, "Only KOL can call this function");
        _;
    }

    /**
     * @dev Constructor
     * @param _kolAddress Address of the KOL
     * @param _dexRouter Address of the DEX router
     * @param _version Router version
     * @param _factoryAddress Address of the factory
     */
    constructor(
        address _kolAddress,
        address _dexRouter,
        string memory _version,
        address _factoryAddress
    ) {
        require(_kolAddress != address(0), "Invalid KOL address");
        require(_dexRouter != address(0), "Invalid DEX router");
        require(_factoryAddress != address(0), "Invalid factory address");

        kolAddress = _kolAddress;
        dexRouter = _dexRouter;
        routerVersion = _version;
        factoryAddress = _factoryAddress;

        // Initial fixed fee (0.01 AVAX in wei)
        fixedFeeAmount = 10000000000000000; // 0.01 AVAX
    }

    /**
     * @dev Allows the KOL to update their fixed fee
     * @param _fixedFeeAmount New fixed fee amount (in wei)
     */
    function updateFixedFee(uint256 _fixedFeeAmount) external override onlyKOL {
        require(_fixedFeeAmount <= 1 ether, "Fee cannot exceed 1 AVAX");

        uint256 oldFee = fixedFeeAmount;
        fixedFeeAmount = _fixedFeeAmount;

        emit FeeUpdated(oldFee, _fixedFeeAmount);
    }

    /**
     * @dev Allows the KOL to withdraw their accumulated fees
     */
    function withdrawFees() external override onlyKOL nonReentrant {
        uint256 amount = accumulatedFees;
        require(amount > 0, "No fees to withdraw");

        accumulatedFees = 0;

        (bool success, ) = kolAddress.call{value: amount}("");
        require(success, "Fee withdrawal failed");

        emit FeesWithdrawn(amount, kolAddress);
    }

    /**
     * @dev Gets the accumulated fees balance
     * @return Accumulated fees balance
     */
    function getAccumulatedFees() external view override returns (uint256) {
        return accumulatedFees;
    }

    /**
     * @dev Updates the accumulated fees balance
     * @param _feeAmount Amount to add
     */
    function _addFee(uint256 _feeAmount) internal {
        accumulatedFees += _feeAmount;
    }

    /**
     * @dev Verifies that the required fee was sent
     * @param _msgValue Value sent with the transaction
     */
    function _verifyFee(uint256 _msgValue) internal view {
        require(_msgValue >= fixedFeeAmount, "Insufficient AVAX for fee");
    }
}