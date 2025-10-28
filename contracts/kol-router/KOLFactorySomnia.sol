// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./KOLFactoryBase.sol";
import "./KOLRouterSomniaV2.sol";

/**
 * @title KOLFactorySomnia
 * @dev Factory for creating and managing KOL routers for Somnia
 */
contract KOLFactorySomnia is KOLFactoryBase {
    /**
     * @dev Constructor
     * @param _somniaRouter Address of Somnia router
     * @param _sherryFoundationAddress Address of Sherry Foundation
     * @param _sherryTreasuryAddress Address of Sherry Treasury
     */
    constructor(
        address _somniaRouter,
        address _sherryFoundationAddress,
        address _sherryTreasuryAddress
    )
        KOLFactoryBase(
            _somniaRouter,
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
        // Create new Somnia KOL router
        KOLRouterSomniaV2 router = new KOLRouterSomniaV2(
            _kolAddress,
            protocolRouter,
            address(this),
            sherryFoundationAddress,
            sherryTreasuryAddress
        );

        return address(router);
    }
}
