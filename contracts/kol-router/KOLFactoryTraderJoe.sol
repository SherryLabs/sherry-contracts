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
     */
    constructor(address _traderJoeRouter) KOLFactoryBase(_traderJoeRouter) {}

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
        // Create new Trader Joe KOL router
        KOLRouterTraderJoe router = new KOLRouterTraderJoe(
            _kolAddress,
            protocolRouter,
            address(this),
            _fixedFeeAmount
        );

        return address(router);
    }
}
