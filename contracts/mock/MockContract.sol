// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract MockContract {
    uint256 public value;
    function setValue(uint256 _value) external {
        value = _value;
    }
    function revertFunction() external pure {
        revert("Function reverted");
    }
}
