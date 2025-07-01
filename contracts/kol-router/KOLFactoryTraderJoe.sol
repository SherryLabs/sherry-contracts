// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./KOLFactoryBase.sol";
import "./KOLRouterTraderJoe.sol";

/**
 * @title KOLFactoryTraderJoe
 * @dev Factory for creating and managing KOL routers for Trader Joe
 */
contract KOLFactoryTraderJoe is KOLFactoryBase {
    /**
     * @dev Constructor
     * @param _traderJoeRouter Address of Trader Joe router
     * @param _sherryFoundationAddress Address of Sherry Foundation
     * @param _sherryTreasuryAddress Address of Sherry Treasury
     */
    constructor(
        address _traderJoeRouter,
        address _sherryFoundationAddress,
        address _sherryTreasuryAddress
    )
        KOLFactoryBase(
            _traderJoeRouter,
            _sherryFoundationAddress,
            _sherryTreasuryAddress
        )
    {}

    /**
     * @dev Creates the specific router implementation
     * @param _kolAddress Address of the KOL
     * @return Address of the new router
     */
    function _createRouterImplementation(
        address _kolAddress
    ) internal override returns (address) {
        // Create new Trader Joe KOL router
        KOLRouterTraderJoe router = new KOLRouterTraderJoe(
            _kolAddress,
            protocolRouter,
            address(this),
            sherryFoundationAddress,
            sherryTreasuryAddress
        );

        return address(router);
    }
}
