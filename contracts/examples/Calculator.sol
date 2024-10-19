// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Calculator {
    uint256 public result;

    function add(uint256 a, uint256 b) public {
        result = a + b;
    }

    function sub(uint256 a, uint256 b) public {
        result = a - b;
    }

    function mul(uint256 a, uint256 b) public {
        result = a * b;
    }

    function div(uint256 a, uint256 b) public {
        result = a / b;
    }
}
