// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/// @title SL1
/// @notice This contract allows interaction with any contract/function on the chain where it is deployed
contract SL1 {
    address public owner;
    uint256 public TX_FEE = 0.01 ether;

    event FunctionExecuted(
        address contractToBeCalled,
        bytes encodedFunctionCall
    );

    constructor() {
        owner = msg.sender;
    }

    function execFunction(
        address _contractToBeCalled,
        bytes memory _encodedFunctionCall
    ) public payable {
        require(msg.value >= TX_FEE, "Insufficient funds");
        (bool success, ) = _contractToBeCalled.call(_encodedFunctionCall);
        require(success, "Function call failed");
        emit FunctionExecuted(_contractToBeCalled, _encodedFunctionCall);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}
