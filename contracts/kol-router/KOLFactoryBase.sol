// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title KOLFactoryBase
 * @dev Abstract base contract for protocol-specific KOL router factories
 */
abstract contract KOLFactoryBase is Ownable {
    using Address for address;

    // Mapping of KOL to their routers
    mapping(address => address[]) kolToRouters;

    // List of deployed routers
    address[] public deployedRouters;

    // Protocol router address
    address public protocolRouter;

    // Sherry Foundation address
    address public sherryFoundationAddress;

    // Sherry Treasury address
    address public sherryTreasuryAddress;

    // Fee configuration (modifiable)
    uint16 public kolFeeRate = 100; // default: 1% (in basis points)
    uint16 public foundationFeeRate = 50; // default: 0.5% (in basis points)
    uint16 public treasuryFeeRate = 50; // default: 0.5% (in basis points)
    uint16 public constant BASIS_POINTS = 10000;

    // Events
    event RouterCreated(address indexed kolAddress, address routerAddress);
    event ProtocolAddressUpdated(address routerAddress);
    event FoundationAddressUpdated(address foundationAddress);
    event TreasuryAddressUpdated(address foundationAddress);
    event FeeRatesUpdated(
        uint16 kolFeeRate,
        uint16 foundationFeeRate,
        uint16 treasuryFeeRate
    );

    /**
     * @dev Constructor
     * @param _protocolRouter Address of the protocol's router
     * @param _sherryFoundationAddress Address of Sherry Foundation
     * @param _sherryTreasuryAddress Address of Sherry Treasury
     */
    constructor(
        address _protocolRouter,
        address _sherryFoundationAddress,
        address _sherryTreasuryAddress
    ) Ownable(msg.sender) {
        require(_protocolRouter != address(0), "Invalid protocol router");
        require(
            _sherryFoundationAddress != address(0),
            "Invalid foundation address"
        );
        require(
            _sherryTreasuryAddress != address(0),
            "Invalid treasury address"
        );

        protocolRouter = _protocolRouter;
        sherryFoundationAddress = _sherryFoundationAddress;
        sherryTreasuryAddress = _sherryTreasuryAddress;
    }

    /**
     * @dev Updates the protocol router address
     * @param _protocolRouter New router address
     */
    function setProtocolRouter(address _protocolRouter) external onlyOwner {
        require(_protocolRouter != address(0), "Invalid router address");
        protocolRouter = _protocolRouter;
        emit ProtocolAddressUpdated(_protocolRouter);
    }

    /**
     * @dev Updates the Sherry Foundation address
     * @param _sherryFoundationAddress New foundation address
     */
    function setSherryFoundationAddress(
        address _sherryFoundationAddress
    ) external onlyOwner {
        require(
            _sherryFoundationAddress != address(0),
            "Invalid foundation address"
        );
        sherryFoundationAddress = _sherryFoundationAddress;
        emit FoundationAddressUpdated(_sherryFoundationAddress);
    }

    /**
     * @dev Updates the Sherry Treasury address
     * @param _sherryTreasuryAddress New foundation address
     */
    function setSherryTreasuryAddress(
        address _sherryTreasuryAddress
    ) external onlyOwner {
        require(
            _sherryTreasuryAddress != address(0),
            "Invalid treasury address"
        );
        sherryTreasuryAddress = _sherryTreasuryAddress;
        emit TreasuryAddressUpdated(_sherryTreasuryAddress);
    }

    /**
     * @dev Updates the fee rates
     * @param _kolFeeRate New KOL fee rate in basis points
     * @param _foundationFeeRate New foundation fee rate in basis points
     */
    function setFeeRates(
        uint16 _kolFeeRate,
        uint16 _foundationFeeRate,
        uint16 _treasuryFeeRate
    ) external onlyOwner {
        require(
            _kolFeeRate + _foundationFeeRate + _treasuryFeeRate <= BASIS_POINTS,
            "Total fee cannot exceed 100%"
        );
        require(
            _kolFeeRate > 0 && _foundationFeeRate > 0 && _treasuryFeeRate > 0,
            "Fee rates must be greater than 0"
        );

        kolFeeRate = _kolFeeRate;
        foundationFeeRate = _foundationFeeRate;
        treasuryFeeRate = _treasuryFeeRate;

        emit FeeRatesUpdated(_kolFeeRate, _foundationFeeRate, _treasuryFeeRate);
    }

    /**
     * @dev Gets the total number of deployed routers of all Kols
     * @return Number of routers
     */
    function getTotalRouters() external view returns (uint256) {
        return deployedRouters.length;
    }

    /**
     * @dev Gets the KOL router by index
     * @param _kolAddress KOL address
     * @param _index Router index
     * @return Router address by index
     */
    function getKOLRouter(
        address _kolAddress,
        uint256 _index
    ) external view returns (address) {
        return kolToRouters[_kolAddress][_index];
    }

    /**
     * @dev Gets the KOL's routers count
     * @param _kolAddress KOL address
     * @return KOL's number of routers
     */
    function getKOLRoutersCount(
        address _kolAddress
    ) external view returns (uint256) {
        return kolToRouters[_kolAddress].length;
    }

    /**
     * @dev Creates a KOL router and handles common registration logic
     * @param _kolAddress KOL address
     * @return routerAddress Address of the new router
     */
    function createKOLRouter(address _kolAddress) external returns (address) {
        require(_kolAddress != address(0), "Invalid KOL address");

        // Create the specific router using the derived class implementation
        address routerAddress = _createRouterImplementation(_kolAddress);

        // Register the router in base contract state
        kolToRouters[_kolAddress].push(routerAddress);
        deployedRouters.push(routerAddress);

        emit RouterCreated(_kolAddress, routerAddress);
        return routerAddress;
    }

    /**
     * @dev Abstract method to create the specific router implementation
     * Must be implemented by derived contracts
     * @param kolAddress Address of the KOL
     * @return Router address
     */
    function _createRouterImplementation(
        address kolAddress
    ) internal virtual returns (address);

    /**
     * @dev Getter functions for fee configuration (used by routers)
     */
    function getKOLFeeRate() external view returns (uint16) {
        return kolFeeRate;
    }

    function getFoundationFeeRate() external view returns (uint16) {
        return foundationFeeRate;
    }

    function getTreasuryFeeRate() external view returns (uint16) {
        return treasuryFeeRate;
    }

    function getTotalFeeRate() external view returns (uint16) {
        return kolFeeRate + foundationFeeRate + treasuryFeeRate;
    }

    function getBasisPoints() external pure returns (uint16) {
        return BASIS_POINTS;
    }
}
