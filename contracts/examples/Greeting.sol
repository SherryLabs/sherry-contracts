//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Greeting {
    string public greeting;

    constructor(string memory _greeting) {
        greeting = _greeting;
    }

    function setGreeting(string memory _greeting) public {
        greeting = _greeting;
    }
}