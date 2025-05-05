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
     * @param kolAddress KOL address
     * @return Router address
     */
    function getKOLRouter(address kolAddress) external view returns (address) {
        return kolToRouter[kolAddress];
    }

    /**
     * @dev Creates a KOL router and handles common registration logic
     * @param kolAddress KOL address
     * @return routerAddress Address of the new router
     */
    function createKOLRouter(address kolAddress) external returns (address) {
        require(kolAddress != address(0), "Invalid KOL address");
        require(kolToRouter[kolAddress] == address(0), "Router already exists for this KOL");

        // Create the specific router using the derived class implementation
        address routerAddress = _createRouterImplementation(kolAddress);

        // Register the router in base contract state
        kolToRouter[kolAddress] = routerAddress;
        deployedRouters.push(routerAddress);

        emit RouterCreated(kolAddress, routerAddress);
        return routerAddress;
    }

    /**
     * @dev Abstract method to create the specific router implementation
     * Must be implemented by derived contracts
     * @param kolAddress Address of the KOL
     * @return Router address
     */
    function _createRouterImplementation(address kolAddress) internal virtual returns (address);
}