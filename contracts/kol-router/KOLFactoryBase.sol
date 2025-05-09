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

    // Mapping of KOL to their router
    mapping(address => address) public kolToRouter;

    // List of deployed routers
    address[] public deployedRouters;

    // Protocol router address
    address public protocolRouter;

    // Events
    event RouterCreated(address indexed kolAddress, address routerAddress);
    event ProtocolAddressUpdated(address routerAddress);

    /**
     * @dev Constructor
     * @param _protocolRouter Address of the protocol's router
     */
    constructor(address _protocolRouter) Ownable(msg.sender) {
        require(_protocolRouter != address(0), "Invalid protocol router");
        protocolRouter = _protocolRouter;
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
     * @dev Gets the total number of deployed routers
     * @return Number of routers
     */
    function getTotalRouters() external view returns (uint256) {
        return deployedRouters.length;
    }

    /**
     * @dev Gets a KOL's router
     * @param _kolAddress KOL address
     * @return Router address
     */
    function getKOLRouter(address _kolAddress) external view returns (address) {
        return kolToRouter[_kolAddress];
    }

    /**
     * @dev Creates a KOL router and handles common registration logic
     * @param _kolAddress KOL address
     * @param _fixedFeeAmount Amount to be subtracted as Fee
     * @return routerAddress Address of the new router
     */
    function createKOLRouter(
        address _kolAddress,
        uint256 _fixedFeeAmount
    ) external returns (address) {
        require(_kolAddress != address(0), "Invalid KOL address");
        require(
            kolToRouter[_kolAddress] == address(0),
            "Router already exists for this KOL"
        );

        // Create the specific router using the derived class implementation
        address routerAddress = _createRouterImplementation(
            _kolAddress,
            _fixedFeeAmount
        );

        // Register the router in base contract state
        kolToRouter[_kolAddress] = routerAddress;
        deployedRouters.push(routerAddress);

        emit RouterCreated(_kolAddress, routerAddress);
        return routerAddress;
    }

    /**
     * @dev Abstract method to create the specific router implementation
     * Must be implemented by derived contracts
     * @param kolAddress Address of the KOL
     * @param _fixedFeeAmount Amount to be subtracted as Fee
     * @return Router address
     */
    function _createRouterImplementation(
        address kolAddress,
        uint256 _fixedFeeAmount
    ) internal virtual returns (address);
}
