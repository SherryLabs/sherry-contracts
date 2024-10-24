//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Greeting {
    string public s_greeting;
    uint256 public s_counter;

    function setGreeting(string memory _greeting) public {
        s_greeting = _greeting;
    }

    function setCounter(uint256 _counter) public {
        s_counter = _counter;
    }
}
