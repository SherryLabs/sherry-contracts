// SPDX-license-Identifier: MIT
pragma solidity ^0.8.25;

import "../../lib/wormhole-solidity-sdk/src/interfaces/IWormholeRelayer.sol";
import "../../lib/wormhole-solidity-sdk/src/interfaces/IWormholeReceiver.sol";

contract SL1MessageAnyReceiver is IWormholeReceiver {
    IWormholeRelayer public s_wormholeRelayer;
    address public s_registrationOwner;

    mapping(uint16 => bytes32) public s_registeredSenders;

    event MessageReceived(string message);
    event SourceChainLogged(uint16 sourceChain, address sender);

    constructor(address _wormholeRelayer) {
        s_wormholeRelayer = IWormholeRelayer(_wormholeRelayer);
        s_registrationOwner = msg.sender;
    }

    modifier isRegisteredSender(uint16 sourceChain, bytes32 sourceAddress) {
        require(s_registeredSenders[sourceChain] == sourceAddress, "Sender not registered");
        _;
    }

    function setRegisteredSender(uint16 sourceChain, bytes32 sourceAddress) external {
        require(msg.sender == s_registrationOwner, "Only the registration owner can set the sender");
        s_registeredSenders[sourceChain] = sourceAddress;
    }

    function receiveWormholeMessages(
        bytes memory payload,
        bytes[] memory,
        bytes32 sourceAddress,
        uint16 sourceChain,
        bytes32
    ) public payable override isRegisteredSender(sourceChain, sourceAddress) {
        require(msg.sender == address(s_wormholeRelayer), "Only the Wormhole Relayer can call this function");

        (string memory message, address sender) = abi.decode(payload, (string, address));

        if (sourceChain != 0) {
            emit SourceChainLogged(sourceChain, sender);
        }

        emit MessageReceived(message);
    }
}
