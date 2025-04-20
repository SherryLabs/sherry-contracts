// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./KOLSwapRouterV1.sol";
import "./KOLSwapRouterV2.sol";

/**
 * @title KOLRouterFactory
 * @dev Factory for creating and managing KOL routers for different versions of Trader Joe
 */
contract KOLRouterFactory is Ownable {
    using Address for address;

    // Mapping of KOL to their routers for each version
    mapping(address => mapping(string => address)) public kolToRouters;

    // List of deployed routers
    address[] public deployedRouters;

    // DEX router addresses
    address public traderJoeRouterV1;
    address public traderJoeRouterV2;

    // Events
    event RouterCreated(address indexed kolAddress, string version, address routerAddress);
    event TokenStatusUpdated(address indexed token, bool allowed);
    event ProtocolAddressUpdated(string protocolName, address routerAddress);

    /**
     * @dev Constructor
     * @param _traderJoeRouterV1 Address of Trader Joe V1 router
     * @param _traderJoeRouterV2 Address of Trader Joe V2 router
     */
    constructor(
        address _traderJoeRouterV1,
        address _traderJoeRouterV2
    ) Ownable(msg.sender) {
        require(_traderJoeRouterV1 != address(0), "Invalid TraderJoe V1 router");
        require(_traderJoeRouterV2 != address(0), "Invalid TraderJoe V2 router");

        traderJoeRouterV1 = _traderJoeRouterV1;
        traderJoeRouterV2 = _traderJoeRouterV2;
    }

    /**
     * @dev Creates a new router for a KOL for a specific DEX version
     * @param kolAddress Address of the KOL
     * @param version Router version ("V1" or "V2")
     * @return Address of the new router
     */
    function createKOLRouter(address kolAddress, string calldata version) external returns (address) {
        require(kolAddress != address(0), "Invalid KOL address");
        require(
            keccak256(bytes(version)) == keccak256(bytes("V1")) ||
            keccak256(bytes(version)) == keccak256(bytes("V2")),
            "Unsupported version"
        );
        require(kolToRouters[kolAddress][version] == address(0), "Router already exists for this KOL and version");

        address routerAddress;

        if (keccak256(bytes(version)) == keccak256(bytes("V1"))) {
            KOLSwapRouterV1 router = new KOLSwapRouterV1(
                kolAddress,
                traderJoeRouterV1,
                address(this)
            );
            routerAddress = address(router);
        } else {
            KOLSwapRouterV2 router = new KOLSwapRouterV2(
                kolAddress,
                traderJoeRouterV2,
                address(this)
            );
            routerAddress = address(router);
        }

        kolToRouters[kolAddress][version] = routerAddress;
        deployedRouters.push(routerAddress);

        emit RouterCreated(kolAddress, version, routerAddress);
        return routerAddress;
    }

    /**
     * @dev Updates the Trader Joe V1 router address
     * @param _traderJoeRouterV1 New router address
     */
    function setTraderJoeRouterV1(address _traderJoeRouterV1) external onlyOwner {
        require(_traderJoeRouterV1 != address(0), "Invalid router address");
        traderJoeRouterV1 = _traderJoeRouterV1;
        emit ProtocolAddressUpdated("TraderJoeV1", _traderJoeRouterV1);
    }

    /**
     * @dev Updates the Trader Joe V2 router address
     * @param _traderJoeRouterV2 New router address
     */
    function setTraderJoeRouterV2(address _traderJoeRouterV2) external onlyOwner {
        require(_traderJoeRouterV2 != address(0), "Invalid router address");
        traderJoeRouterV2 = _traderJoeRouterV2;
        emit ProtocolAddressUpdated("TraderJoeV2", _traderJoeRouterV2);
    }

    /**
     * @dev Gets the total number of deployed routers
     * @return Number of routers
     */
    function getTotalRouters() external view returns (uint256) {
        return deployedRouters.length;
    }

    /**
     * @dev Gets a KOL's router for a specific version
     * @param kolAddress KOL address
     * @param version Router version
     * @return Router address
     */
    function getKOLRouter(address kolAddress, string calldata version) external view returns (address) {
        return kolToRouters[kolAddress][version];
    }
}