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
     */
    constructor(address _arenaSwapRouter) KOLFactoryBase(_arenaSwapRouter) {}

    /**
     * @dev Creates the specific router implementation
     * @param _kolAddress Address of the KOL
     * @param _fixedFeeAmount Amount to be subtracted as Fee
     * @return Address of the new router
     */
    function _createRouterImplementation(
        address _kolAddress,
        uint256 _fixedFeeAmount
    ) internal override returns (address) {
        // Create new ArenaSwap KOL router
        KOLRouterArenaSwap router = new KOLRouterArenaSwap(
            _kolAddress,
            protocolRouter,
            address(this),
            _fixedFeeAmount
        );

        return address(router);
    }
}
