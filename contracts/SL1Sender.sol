// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../teleporter/contracts/teleporter/ITeleporterMessenger.sol";

contract SL1Sender {
    //ITeleporterMessenger public immutable messenger =
    ITeleporterMessenger public messenger =
        ITeleporterMessenger(0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf);

    // Blockchain ID
    // SL1 Blockchain: 0xdb76a6c20fd0af4851417c79c479ebb1e91b3d4e7e57116036d203e3692a0856
    // Dispatch Blockcchain: 0x9f3be606497285d0ffbb5ac9ba24aa60346a9b1812479ed66cb329f394a4b1c7
    function sendMessage(
        address _destinationContract,
        bytes calldata _encodedFunctionCall,
        address _destinationAdress,
        bytes32 _destinationChain,
        uint256 _gasLimit
    ) public {
        bytes memory functionCall = createArbitraryMessage(
            _destinationContract,
            _encodedFunctionCall
        );

        messenger.sendCrossChainMessage(
            TeleporterMessageInput({
                destinationBlockchainID: _destinationChain, //0x9f3be606497285d0ffbb5ac9ba24aa60346a9b1812479ed66cb329f394a4b1c7, //bytes32
                destinationAddress: _destinationAdress,
                feeInfo: TeleporterFeeInfo({
                    feeTokenAddress: address(0),
                    amount: 0
                }),
                requiredGasLimit: _gasLimit,
                allowedRelayerAddresses: new address[](0),
                message: functionCall
            })
        );
    }

    function createArbitraryMessage(
        address _destinationContract,
        bytes memory _encodedFunctionCall
    ) public returns (bytes memory) {
        bytes memory message = abi.encode(
            _destinationContract,
            _encodedFunctionCall
        );
        return message;
    }

    function updateMessenger(address _newMessenger) public {
        messenger = ITeleporterMessenger(_newMessenger);
    }
}
