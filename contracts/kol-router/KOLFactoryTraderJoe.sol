// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./KOLFactoryBase.sol";
import "./KOLRouterTraderJoe.sol";

/**
 * @title KOLFactoryTraderJoe
 * @dev Factory for creating and managing KOL routers for Uniswap
 */
contract KOLFactoryTraderJoe is KOLFactoryBase {
    /**
     * @dev Constructor
     * @param _traderJoeRouter Address of Uniswap router
     */
    constructor(address _traderJoeRouter) KOLFactoryBase(_traderJoeRouter) {}

    /**
     * @dev Creates the specific router implementation
     * @param kolAddress Address of the KOL
     * @return Address of the new router
     */
    function _createRouterImplementation(address kolAddress) internal override returns (address) {
        // Create new Uniswap KOL router
        KOLRouterTraderJoe router = new KOLRouterTraderJoe(
            kolAddress,
            protocolRouter,
            address(this)
        );

        return address(router);
    }
}