// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "../KOLFactoryBase.sol";
import "./KOLRouterSomniaV2TwoFunc.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

/**
 * @title KOLFactorySomniaCloneable
 * @dev Factory for creating and managing KOL routers for Somnia using minimal proxy pattern (EIP-1167)
 */
contract KOLFactorySomniaCloneable is KOLFactoryBase {
    // Implementation contract address
    address public immutable implementation;

    /**
     * @dev Constructor
     * @param _somniaRouter Address of Somnia router
     * @param _sherryFoundationAddress Address of Sherry Foundation
     * @param _sherryTreasuryAddress Address of Sherry Treasury
     * @param _implementation Address of the router implementation contract
     */
    constructor(
        address _somniaRouter,
        address _sherryFoundationAddress,
        address _sherryTreasuryAddress,
        address _implementation
    )
        KOLFactoryBase(
            _somniaRouter,
            _sherryFoundationAddress,
            _sherryTreasuryAddress
        )
    {
        require(_implementation != address(0), "Invalid implementation address");
        implementation = _implementation;
    }

    /**
     * @dev Creates the specific router implementation using clone pattern
     * @param _kolAddress Address of the KOL
     * @return Address of the new router
     */
    function _createRouterImplementation(
        address _kolAddress
    ) internal override returns (address) {
        // Clone the implementation contract
        address clone = Clones.clone(implementation);

        // Initialize the clone
        KOLRouterSomniaV2TwoFunc(payable(clone)).initialize(
            _kolAddress,
            protocolRouter,
            address(this),
            sherryFoundationAddress,
            sherryTreasuryAddress
        );

        return clone;
    }
}
