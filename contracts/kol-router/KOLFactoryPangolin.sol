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
     */
    constructor(address _pangolinRouter) KOLFactoryBase(_pangolinRouter) {}

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
        // Create new Pangolin KOL router
        KOLRouterPangolinV2 router = new KOLRouterPangolinV2(
            _kolAddress,
            protocolRouter,
            address(this),
            _fixedFeeAmount
        );

        return address(router);
    }
}
