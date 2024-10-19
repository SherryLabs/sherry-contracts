// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../teleporter/contracts/teleporter/ITeleporterReceiver.sol";

contract SL1AnyChainReceiver is ITeleporterReceiver {
    event ReceivedMessage(address indexed sender, bytes message);
    event ErrorMessage(string message);

    function receiveTeleporterMessage(
        bytes32,
        address,
        bytes calldata message
    ) external {
        (address targetContract, bytes memory encodedFunctionCall) = abi.decode(
            message,
            (address, bytes)
        );
        (bytes4 sig, bytes memory params) = abi.decode(
            encodedFunctionCall,
            (bytes4, bytes)
        );

        bytes memory callData = abi.encodePacked(sig, params);
        (bool success, bytes memory returnData) = targetContract.call(callData);

        if (!success) {
            emit ErrorMessage(_getRevertMsg(returnData));
        } else {
            emit ReceivedMessage(targetContract, returnData);
        }
    }

    function _getRevertMsg(
        bytes memory _returnData
    ) internal pure returns (string memory) {
        if (_returnData.length < 68) return "Transaction reverted silently";

        assembly {
            // Saltar el selector de la función (4 bytes) y el tamaño de los datos (32 bytes)
            _returnData := add(_returnData, 0x04)
        }
        return abi.decode(_returnData, (string)); // Decodificar el mensaje de revert
    }
}
