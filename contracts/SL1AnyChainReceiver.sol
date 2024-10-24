// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../teleporter/contracts/teleporter/ITeleporterReceiver.sol";

/// @title SL1AnyChainReceiver
/// @notice This contract receives cross-chain messages and executes the encoded function calls on the target contract.
contract SL1AnyChainReceiver is ITeleporterReceiver {
    /// @notice Emitted when a message is successfully received and executed.
    /// @param sender The address of the target contract.
    /// @param message The return data from the executed function call.
    event MessageReceived(address indexed sender, bytes message);

    /// @notice Emitted when there is an error executing the function call.
    /// @param message The error message.
    event ErrorMessage(string message);

    /// @notice Receives a cross-chain message, decodes it, and executes the function call on the target contract.
    /// @param message The encoded message containing the target contract address and the encoded function call.
    function receiveTeleporterMessage(
        bytes32, // Unused parameter
        address, // Unused parameter
        bytes calldata message
    ) external override {
        // Decode the message to get the target contract address and the encoded function call
        (address targetContract, bytes memory encodedFunctionCall) = abi.decode(message, (address, bytes));

        // Execute the function call on the target contract
        (bool success, bytes memory returnData) = targetContract.call(encodedFunctionCall);

        // Emit an event based on the success or failure of the function call
        if (!success) {
            emit ErrorMessage(_getRevertMsg(returnData));
        } else {
            emit MessageReceived(targetContract, returnData);
        }
    }

    /// @notice Decodes the revert message from the return data.
    /// @param _returnData The return data from the failed function call.
    /// @return The decoded revert message.
    function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
        // If the return data length is less than 68, it is not a revert message
        if (_returnData.length < 68) return "Transaction reverted silently";

        assembly {
            // Skip the function selector (4 bytes) and the data length (32 bytes)
            _returnData := add(_returnData, 0x04)
        }
        // Decode and return the revert message
        return abi.decode(_returnData, (string));
    }
}
