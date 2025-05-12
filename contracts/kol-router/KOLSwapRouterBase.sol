// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title KOLSwapRouterBase
 * @dev Abstract base contract for KOL routers
 */
abstract contract KOLSwapRouterBase is ReentrancyGuard {
    using Address for address;

    address public kolAddress;
    address public factoryAddress;
    address public dexRouter;
    uint256 public fixedFeeAmount;

    event SwapExecuted(address kol, address sender, uint256 fee);
    event FeeUpdated(uint256 oldFee, uint256 newFee);
    event FeesWithdrawn(uint256 amount, address recipient);

    // Modifier to restrict access to KOL only
    modifier onlyKOL() {
        require(msg.sender == kolAddress, "Only KOL can call this function");
        _;
    }

    // Verifies that the required fee was sent
    modifier verifyFee(uint256 _msgValue)  {
        require(
            _msgValue >= fixedFeeAmount,
            "KOLSwapRouter: INSUFFICIENT_NATIVE_FOR_FEE"
        );
        _;
    }

    /**
     * @dev Constructor
     * @param _kolAddress Address of the KOL
     * @param _dexRouter Address of the DEX router
     * @param _factoryAddress Address of the factory
     * @param _fixedFeeAmount Amount to be subtracted as Fee
     */
    constructor(
        address _kolAddress,
        address _dexRouter,
        address _factoryAddress,
        uint256 _fixedFeeAmount
    ) {
        require(_kolAddress != address(0), "Invalid KOL address");
        require(_dexRouter != address(0), "Invalid DEX router");
        require(_factoryAddress != address(0), "Invalid factory address");

        kolAddress = _kolAddress;
        dexRouter = _dexRouter;
        factoryAddress = _factoryAddress;
        fixedFeeAmount = _fixedFeeAmount;
    }

    /**
     * @dev Allows the KOL to update their fixed fee
     * @param _fixedFeeAmount New fixed fee amount (in wei)
     */
    function updateFixedFee(uint256 _fixedFeeAmount) external onlyKOL {
        require(_fixedFeeAmount != 0, "Fee cannot be 0");

        uint256 oldFee = fixedFeeAmount;
        fixedFeeAmount = _fixedFeeAmount;

        emit FeeUpdated(oldFee, _fixedFeeAmount);
    }

    /**
     * @dev Allows the KOL to withdraw their accumulated fees
     */
    function withdrawFees() external onlyKOL nonReentrant {
        uint256 amount = address(this).balance;
        require(amount > 0, "No fees to withdraw");

        (bool success, ) = kolAddress.call{value: amount}(new bytes(0));
        require(success, "Fee withdrawal failed");

        emit FeesWithdrawn(amount, kolAddress);
    }
}