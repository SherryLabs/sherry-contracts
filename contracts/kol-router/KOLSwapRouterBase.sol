// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./interfaces/IKOLFactory.sol";

/**
 * @title KOLSwapRouterBase
 * @dev Abstract base contract for KOL routers with percentage-based fees
 */
abstract contract KOLSwapRouterBase is ReentrancyGuard {
    using Address for address;
    using SafeERC20 for IERC20;

    address public kolAddress;
    IKOLFactory public factory;
    address public dexRouter;
    address public sherryFoundationAddress;
    address public sherryTreasuryAddress;

    struct NetAmount {
        uint256 netAmount;
        uint256 kolFee;
        uint256 foundationFee;
        uint256 treasuryFee;
    }

    event SwapExecuted(
        address indexed kol,
        address indexed trader,
        address tokenIn,
        address indexed tokenOut,
        uint256 kolFee,
        uint256 foundationFee,
        uint256 treasuryFee
    );

    // Modifier to restrict access to KOL only
    modifier onlyKOL() {
        require(msg.sender == kolAddress, "Only KOL can call this function");
        _;
    }

    /**
     * @dev Constructor
     * @param _kolAddress Address of the KOL
     * @param _dexRouter Address of the DEX router
     * @param _factoryAddress Address of the factory
     * @param _sherryFoundationAddress Address of Sherry Foundation
     * @param _sherryTreasuryAddress Address of Sherry Treasury
     */
    constructor(
        address _kolAddress,
        address _dexRouter,
        address _factoryAddress,
        address _sherryFoundationAddress,
        address _sherryTreasuryAddress
    ) {
        require(_kolAddress != address(0), "Invalid KOL address");
        require(_dexRouter != address(0), "Invalid DEX router");
        require(_factoryAddress != address(0), "Invalid factory address");
        require(
            _sherryFoundationAddress != address(0),
            "Invalid foundation address"
        );
        require(
            _sherryTreasuryAddress != address(0),
            "Invalid treasury address"
        );

        kolAddress = _kolAddress;
        dexRouter = _dexRouter;
        factory = IKOLFactory(_factoryAddress);
        sherryFoundationAddress = _sherryFoundationAddress;
        sherryTreasuryAddress = _sherryTreasuryAddress;
    }

    /**
     * @dev Calculates and deducts fees from input amount
     * @param inputAmount The original input amount
     * @param tokenAddress Address of the token (address(0) for native)
     * @return netAmount Amount after fees deduction and fee data
     */
    function _deductFees(
        uint256 inputAmount,
        address tokenAddress
    ) internal returns (NetAmount memory) {
        uint16 kolFeeRate = factory.getKOLFeeRate();
        uint16 foundationFeeRate = factory.getFoundationFeeRate();
        uint16 treasuryFeeRate = factory.getTreasuryFeeRate();
        uint16 basisPoints = factory.getBasisPoints();

        uint256 kolFee = (inputAmount * kolFeeRate) / basisPoints;
        uint256 foundationFee = (inputAmount * foundationFeeRate) / basisPoints;
        uint256 treasuryFee = (inputAmount * treasuryFeeRate) / basisPoints;

        // Send foundation and treasury fee directly to respective addresses
        if (tokenAddress == address(0)) {
            // Native token
            (bool successF, ) = sherryFoundationAddress.call{
                value: foundationFee
            }("");
            require(successF, "KOLSwapRouter: FUNDATION_FEE_TRANSFER_FAILED");
            (bool successT, ) = sherryTreasuryAddress.call{value: treasuryFee}(
                ""
            );
            require(successT, "KOLSwapRouter: TREASURY_FEE_TRANSFER_FAILED");
        } else {
            // ERC20 token
            IERC20(tokenAddress).safeTransfer(
                sherryFoundationAddress,
                foundationFee
            );
            IERC20(tokenAddress).safeTransfer(
                sherryTreasuryAddress,
                treasuryFee
            );
        }

        uint256 netAmount = inputAmount - kolFee - foundationFee - treasuryFee;

        return
            NetAmount({
                netAmount: netAmount,
                kolFee: kolFee,
                foundationFee: foundationFee,
                treasuryFee: treasuryFee
            });
    }

    /**
     * @notice Calculates the net amount after deducting total fees from the given input amount.
     * @param _inputAmount The original amount before fees.
     * @return The net amount after fee deduction.
     */
    function calculateNetAmount(
        uint256 _inputAmount
    ) external view returns (uint256) {
        uint16 totalFeeRate = factory.getTotalFeeRate();
        uint16 basisPoints = factory.getBasisPoints();
        uint256 totalFee = (_inputAmount * totalFeeRate) / basisPoints;

        return _inputAmount - totalFee;
    }

    /**
     * @dev Allows the KOL to withdraw their accumulated fees for multiple tokens including native
     * @param tokenAddresses Array of token addresses (address(0) for native)
     */
    function withdrawKOLFees(
        address[] calldata tokenAddresses
    ) external onlyKOL nonReentrant {
        bool hasWithdrawn = false;

        // Always check and withdraw native tokens first if there's balance
        uint256 nativeAmount = address(this).balance;
        if (nativeAmount > 0) {
            (bool success, ) = kolAddress.call{value: nativeAmount}("");
            require(success, "Native fee withdrawal failed");
            hasWithdrawn = true;
        }

        // Withdraw specified ERC20 tokens
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            if (tokenAddresses[i] == address(0)) continue;

            uint256 amount = IERC20(tokenAddresses[i]).balanceOf(address(this));
            if (amount > 0) {
                IERC20(tokenAddresses[i]).safeTransfer(kolAddress, amount);
                hasWithdrawn = true;
            }
        }

        require(hasWithdrawn, "No fees to withdraw");
    }

    /**
     * @dev Get KOL fee balance for a specific token
     * @param tokenAddress Address of the token (address(0) for native)
     * @return Fee balance
     */
    function getKOLFeeBalance(
        address tokenAddress
    ) external view returns (uint256) {
        if (tokenAddress == address(0)) {
            return address(this).balance;
        } else {
            return IERC20(tokenAddress).balanceOf(address(this));
        }
    }

    /**
     * @dev Get KOL fee balances for multiple tokens
     * @param tokenAddresses Array of token addresses
     * @return balances Array of fee balances
     */
    function getKOLFeeBalances(
        address[] calldata tokenAddresses
    ) external view returns (uint256[] memory balances) {
        balances = new uint256[](tokenAddresses.length);
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            if (tokenAddresses[i] == address(0)) {
                balances[i] = address(this).balance;
            } else {
                balances[i] = IERC20(tokenAddresses[i]).balanceOf(
                    address(this)
                );
            }
        }
    }
}
