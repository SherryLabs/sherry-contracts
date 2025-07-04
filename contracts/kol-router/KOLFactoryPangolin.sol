// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./KOLFactoryBase.sol";
import "./KOLRouterPangolinV2.sol";

/**
 * @title KOLFactoryPangolin
 * @dev Factory for creating and managing KOL routers for Pangolin
 */
contract KOLFactoryPangolin is KOLFactoryBase {
    /**
     * @dev Constructor
     * @param _pangolinRouter Address of Pangolin router
     * @param _sherryFoundationAddress Address of Sherry Foundation
     * @param _sherryTreasuryAddress Address of Sherry Treasury
     */
    constructor(
        address _pangolinRouter,
        address _sherryFoundationAddress,
        address _sherryTreasuryAddress
    )
        KOLFactoryBase(
            _pangolinRouter,
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
        // Create new Pangolin KOL router
        KOLRouterPangolinV2 router = new KOLRouterPangolinV2(
            _kolAddress,
            protocolRouter,
            address(this),
            sherryFoundationAddress,
            sherryTreasuryAddress
        );

        return address(router);
    }
}
