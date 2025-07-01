// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./KOLFactoryBase.sol";
import "./KOLRouterArenaSwap.sol";

/**
 * @title KOLFactoryArenaSwap
 * @dev Factory for creating and managing KOL routers for ArenaSwap
 */
contract KOLFactoryArenaSwap is KOLFactoryBase {
    /**
     * @dev Constructor
     * @param _arenaSwapRouter Address of ArenaSwap router
     * @param _sherryFoundationAddress Address of Sherry Foundation
     * @param _sherryTreasuryAddress Address of Sherry Treasury
     */
    constructor(
        address _arenaSwapRouter,
        address _sherryFoundationAddress,
        address _sherryTreasuryAddress
    )
        KOLFactoryBase(
            _arenaSwapRouter,
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
        // Create new ArenaSwap KOL router
        KOLRouterArenaSwap router = new KOLRouterArenaSwap(
            _kolAddress,
            protocolRouter,
            address(this),
            sherryFoundationAddress,
            sherryTreasuryAddress
        );

        return address(router);
    }
}
