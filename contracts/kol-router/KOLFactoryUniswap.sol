// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./KOLFactoryBase.sol";
import "./KOLRouterUniswap.sol";

/**
 * @title KOLFactoryUniswap
 * @dev Factory for creating and managing KOL routers for Uniswap
 */
contract KOLFactoryUniswap is KOLFactoryBase {
    /**
     * @dev Constructor
     * @param _uniswapRouter Address of Uniswap router
     */
    constructor(address _uniswapRouter) KOLFactoryBase(_uniswapRouter) {}

    /**
     * @dev Creates the specific router implementation
     * @param kolAddress Address of the KOL
     * @param _fixedFeeAmount Amount to be subtracted as Fee
     * @return Address of the new router
     */
    function _createRouterImplementation(
        address kolAddress,
        uint256 _fixedFeeAmount
    ) internal override returns (address) {
        // Create new Uniswap KOL router
        KOLRouterUniswap router = new KOLRouterUniswap(
            kolAddress,
            protocolRouter,
            address(this),
            _fixedFeeAmount
        );

        return address(router);
    }
}
