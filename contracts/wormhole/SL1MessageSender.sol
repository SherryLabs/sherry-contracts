// SPDX-license-Identifier: MIT
pragma solidity ^0.8.25;

import "../../lib/wormhole-solidity-sdk/src/interfaces/IWormholeRelayer.sol";

contract SL1MessageSender {
    IWormholeRelayer public s_wormholeRelayer;
    uint256 constant GAS_LIMIT = 200_000;

    constructor(address _wormholeRelayer) {
        s_wormholeRelayer = IWormholeRelayer(_wormholeRelayer);
    }

    function quoteCrossChainCost(uint16 _targetChain) public view returns (uint256 cost) {
        (cost,) = s_wormholeRelayer.quoteEVMDeliveryPrice(_targetChain, 0, GAS_LIMIT);
    }

    function sendMessage(uint16 _targetChain, address _targetAddress, string calldata _message)
        external
        payable //bytes memory _payload,
    //uint256 _gasLimit
    {
        uint256 cost = quoteCrossChainCost(_targetChain);
        s_wormholeRelayer.sendPayloadToEvm{value: cost}(
            _targetChain, _targetAddress, abi.encode(_message, msg.sender), 0, GAS_LIMIT
        );
    }
}
