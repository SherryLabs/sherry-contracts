// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "lib/wormhole-solidity-sdk/src/interfaces/IWormholeRelayer.sol";
import "lib/wormhole-solidity-sdk/src/interfaces/IWormholeReceiver.sol";

contract SL1MessageReceiver is IWormholeReceiver {
    IWormholeRelayer public s_wormholeRelayer;
    address public s_registrationOwner;
    bytes public s_payload;
    address public s_lastSender;
    bytes public s_lastEncodedFunctionCall;
    address public s_lastContractToBeCalled;
    bytes32 public s_sourceAddress;

    mapping(uint16 => bytes32) public s_registeredSenders;

    event MessageInfoReceived(bytes32 sourceAddress, bytes payload);
    event SourceChainLogged(uint16 sourceChain, address sender);
    event FunctionExecuted(
        address contractToBeCalled,
        bytes encodedFunctionCall
    );
    event FunctionCallError(string message);
    event SenderRegistered(uint16 sourceChain, bytes32 sourceAddress);
    event Withdraw(address indexed owner, uint256 amount);

    constructor(address _wormholeRelayer) {
        s_wormholeRelayer = IWormholeRelayer(_wormholeRelayer);
        s_registrationOwner = msg.sender;
    }

    modifier isRegisteredSender(uint16 sourceChain, bytes32 sourceAddress) {
        require(
            s_registeredSenders[sourceChain] == sourceAddress,
            "Sender not registered"
        );
        _;
    }

    function setRegisteredSender(
        uint16 sourceChain,
        bytes32 sourceAddress
    ) external onlyOwner {
        s_registeredSenders[sourceChain] = sourceAddress;
        emit SenderRegistered(sourceChain, sourceAddress);
    }

    function receiveWormholeMessages(
        bytes memory payload,
        bytes[] memory,
        bytes32 sourceAddress,
        uint16 sourceChain,
        bytes32
    ) public payable override isRegisteredSender(sourceChain, sourceAddress) {
        require(
            msg.sender == address(s_wormholeRelayer),
            "Only the Wormhole Relayer can call this function"
        );

        s_payload = payload;

        emit MessageInfoReceived(sourceAddress, payload);

        (
            address contractToBeCalled,
            address sender,
            bytes memory encodedFunctionCall
        ) = abi.decode(payload, (address, address, bytes));

        s_lastSender = sender;
        s_lastEncodedFunctionCall = encodedFunctionCall;
        s_lastContractToBeCalled = contractToBeCalled;
        s_sourceAddress = sourceAddress;

        (bool success, ) = contractToBeCalled.call{value: msg.value}(
            encodedFunctionCall
        );

        if (!success) {
            emit FunctionCallError("Error executing function call");
        } else {
            emit FunctionExecuted(contractToBeCalled, encodedFunctionCall);
        }
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(msg.sender).transfer(balance);
        emit Withdraw(msg.sender, balance);
    }

    modifier onlyOwner() {
        require(msg.sender == s_registrationOwner, "Only the owner can call this function");
        _;
    }
}
