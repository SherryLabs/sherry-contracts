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
    function getKOLRouter(address _kolAddress, uint256 _index) external view returns (address) {
        return kolToRouters[_kolAddress][_index];
    }

    /**
     * @dev Gets the KOL's routers count
     * @param _kolAddress KOL address
     * @return KOL's number of routers
     */
    function getKOLRoutersCount(address _kolAddress) external view returns (uint256) {
        return kolToRouters[_kolAddress].length;
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

        // Create the specific router using the derived class implementation
        address routerAddress = _createRouterImplementation(
            _kolAddress,
            _fixedFeeAmount
        );

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
     * @param _fixedFeeAmount Amount to be subtracted as Fee
     * @return Router address
     */
    function _createRouterImplementation(
        address kolAddress,
        uint256 _fixedFeeAmount
    ) internal virtual returns (address);
}
