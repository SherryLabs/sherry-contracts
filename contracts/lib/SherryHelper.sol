// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SherryHelper {
    /// @notice Creates an arbitrary message to be sent to a specified contract.
    /// @param _contractToBeCalled The address of the contract on the destination blockchain.
    /// @param _encodedFunctionCall The encoded function call to be executed on the destination contract.
    /// @return The encoded arbitrary message.
    function createArbitraryMessage(address _contractToBeCalled, bytes memory _encodedFunctionCall)
        public
        pure
        returns (bytes memory)
    {
        // Encode the destination contract address and the function call into a single message
        bytes memory message = abi.encode(_contractToBeCalled, _encodedFunctionCall);
        return message;
    }
}