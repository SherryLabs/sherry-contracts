
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract CheckSender {
    event Log(address indexed sender, bytes data);


    function checkSender() public {
        emit Log(msg.sender, msg.data);
    }
}