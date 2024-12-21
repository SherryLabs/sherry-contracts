// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Sherry Contract
/// @notice A contract that allows execution of function calls on other contracts
/// @dev Acts as a proxy contract to execute functions on other contracts
contract Sherry is Ownable(msg.sender), Pausable {
    /// @notice Minimum call data length (4 bytes for function selector)
    uint256 public constant MIN_DATA_LENGTH = 4;

    /// @notice Event emitted when a function is successfully executed
    /// @param contractToBeCalled The address of the contract that was called
    /// @param encodedFunctionCall The encoded function call data that was executed
    event FunctionExecuted(
        address contractToBeCalled,
        bytes encodedFunctionCall
    );

    /// @notice Event emitted when a function execution fails
    /// @param contractToBeCalled The address of the contract that was called
    /// @param encodedFunctionCall The encoded function call data that failed
    /// @param reason The reason for the failure
    event FunctionFailed(
        address indexed contractToBeCalled,
        bytes encodedFunctionCall,
        string reason
    );

    /// @notice Executes a function call on another contract
    /// @dev Requires a minimum transaction fee to be paid
    /// @param _contractToBeCalled The address of the contract to call
    /// @param _encodedFunctionCall The encoded function call data to execute
    function sendMessage(
        address _contractToBeCalled,
        bytes memory _encodedFunctionCall
    ) public payable whenNotPaused {
        require(_contractToBeCalled != address(0), "Invalid contract address");
        require(
            _encodedFunctionCall.length >= MIN_DATA_LENGTH,
            "Invalid function call data"
        );


        (bool success, bytes memory returnData) = _contractToBeCalled.call(
            _encodedFunctionCall
        );

        if (success) {
            emit FunctionExecuted(_contractToBeCalled, _encodedFunctionCall);
        } else {
            // Extract revert reason if available
            string memory reason = _getRevertMsg(returnData);
            emit FunctionFailed(
                _contractToBeCalled,
                _encodedFunctionCall,
                reason
            );
            revert(reason);
        }
    }

    /// @notice Extracts the revert message from return data
    /// @dev Internal function to parse revert messages
    /// @param _returnData The return data from a failed call
    function _getRevertMsg(
        bytes memory _returnData
    ) internal pure returns (string memory) {
        if (_returnData.length < 68) return "Transaction reverted silently";
        assembly {
            _returnData := add(_returnData, 0x04)
        }
        return abi.decode(_returnData, (string));
    }

    /// @notice Allows owner to pause contract functionality
    function pause() external onlyOwner {
        _pause();
    }

    /// @notice Allows owner to unpause contract functionality
    function unpause() external onlyOwner {
        _unpause();
    }

    /// @notice Prevents direct payments to the contract
    receive() external payable {
        revert("Direct payments not accepted");
    }
}
