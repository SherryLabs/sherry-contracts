// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "lib/wormhole-solidity-sdk/src/TokenBase.sol";
import "lib/wormhole-solidity-sdk/src/interfaces/IERC20.sol";

contract CrossChainSender is TokenSender {
    uint256 constant GAS_LIMIT = 250_000;

    constructor(
        address _wormholeRelayer,
        address _tokenBridge,
        address _wormhole
    ) TokenBase(_wormholeRelayer, _tokenBridge, _wormhole) {}

    // Function to get the estimated cost for cross-chain deposit
    function quoteCrossChainDeposit(
        uint16 _targetChain
    ) public view returns (uint256 cost) {
        uint256 deliveryCost;
        (deliveryCost, ) = wormholeRelayer.quoteEVMDeliveryPrice(
            _targetChain,
            0,
            GAS_LIMIT
        );

        cost = deliveryCost + wormhole.messageFee();
    }

    // Function to send tokens and payload across chains
    function sendCrossChainDeposit(
        uint16 _targetChain,
        address _targetReceiver,
        address _to,
        uint256 _amount,
        address _token
    ) public payable {
        uint256 cost = quoteCrossChainDeposit(_targetChain);
        require(
            msg.value == cost,
            "msg.value must equal quoteCrossChainDeposit(targetChain)"
        );

        IERC20(_token).transferFrom(msg.sender, address(this), _amount);

        bytes memory payload = abi.encode(_to);

        sendTokenWithPayloadToEvm(
            _targetChain,
            _targetReceiver,
            payload,
            0,
            GAS_LIMIT,
            _token,
            _amount
        );
    }
}





