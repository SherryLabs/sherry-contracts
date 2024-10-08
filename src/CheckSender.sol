
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract CheckSender {
    address public lastSender;
    address public lastOrigin;
    event Log(address indexed sender, bytes data);

    function checkSender() public {
        lastSender = msg.sender;
        lastOrigin = tx.origin;
        emit Log(msg.sender, msg.data);
    }
}