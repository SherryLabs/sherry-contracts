// SPDX-license-Identifier: MIT
pragma solidity ^0.8.25;

import "../../lib/wormhole-solidity-sdk/src/interfaces/IWormholeRelayer.sol";
import "../../lib/wormhole-solidity-sdk/src/interfaces/IWormholeReceiver.sol";

contract SL1MessageAnyReceiver is IWormholeReceiver {
    IWormholeRelayer public s_wormholeRelayer;
    address public s_registrationOwner;
    bytes public s_payload;
    string public s_lastMessage;
    address public s_lastSender;
    bytes32 public s_lastSourceAddress;
    uint16 public s_lastSourceChain;

    mapping(uint16 => bytes32) public s_registeredSenders;

    event MessageReceived(string message);
    event MessageInfoReceived(bytes32 sourceAddress, bytes payload);
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
    //) public payable override isRegisteredSender(sourceChain, sourceAddress) {
    ) public payable override {
        //require(msg.sender == address(s_wormholeRelayer), "Only the Wormhole Relayer can call this function");
        s_payload = payload;
        //emit MessageInfoReceived(sourceAddress, payload);
        //(string memory message, address sender) = abi.decode(payload, (string, address));
        (string memory message, address sender) = abi.decode(payload, (string, address));
        
        s_lastMessage = message;
        s_lastSender = sender;
        //s_lastSourceAddress = sourceAddress;
        //s_lastSourceChain = sourceChain;

        if (sourceChain != 0) {
            //emit SourceChainLogged(sourceChain, msg.sender);
        }

        //emit MessageReceived(message);
    }
}
