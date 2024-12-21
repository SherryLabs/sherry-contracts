// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../../teleporter/contracts/teleporter/ITeleporterMessenger.sol";

/// @title SL1Sender
/// @notice This contract allows sending arbitrary messages to any contract on any blockchain using the Teleporter protocol.
contract SL1Sender {
    /// @notice The Teleporter messenger contract used to send cross-chain messages.
    ITeleporterMessenger public messenger = ITeleporterMessenger(0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf);

    /// @notice Sends a cross-chain message to a specified contract on a specified blockchain.
    /// @param _contractToBeCalled The address of the contract on the destination blockchain.
    /// @param _encodedFunctionCall The encoded function call to be executed on the destination contract.
    /// @param _destinationAdress The address of the destination contract.
    /// @param _destinationChain The identifier of the destination blockchain.
    /// @param _gasLimit The gas limit for the function call on the destination blockchain.
    function sendMessage(
        address _contractToBeCalled,
        bytes calldata _encodedFunctionCall,
        address _destinationAdress,
        bytes32 _destinationChain,
        uint256 _gasLimit
    ) public {
        // Create the arbitrary message to be sent
        bytes memory functionCall = createArbitraryMessage(_contractToBeCalled, _encodedFunctionCall);

        // Send the cross-chain message using the Teleporter messenger
        messenger.sendCrossChainMessage(
            TeleporterMessageInput({
                destinationBlockchainID: _destinationChain, // Identifier of the destination blockchain
                destinationAddress: _destinationAdress, // Address of the destination contract
                feeInfo: TeleporterFeeInfo({
                    feeTokenAddress: address(0), // Address of the token used to pay fees (0 indicates native token)
                    amount: 0 // Amount of the fee token to be paid
                }),
                requiredGasLimit: _gasLimit, // Gas limit for the function call on the destination blockchain
                allowedRelayerAddresses: new address[](0), // List of allowed relayer addresses (empty indicates any relayer)
                message: functionCall // The arbitrary message to be sent
            })
        );
    }

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
