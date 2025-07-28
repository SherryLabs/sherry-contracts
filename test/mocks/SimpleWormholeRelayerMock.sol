// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract SimpleWormholeRelayerMock {
    event MessageSent(
        uint16 targetChain,
        address targetAddress,
        bytes payload,
        uint256 receiverValue,
        uint256 gasLimit
    );
    
    function quoteEVMDeliveryPrice(
        uint16 targetChain,
        uint256 receiverValue,
        uint256 gasLimit
    ) external pure returns (uint256 nativePriceQuote, uint256 targetChainRefundPerGasUnused) {
        nativePriceQuote = 0.01 ether;
        targetChainRefundPerGasUnused = 0;
    }
    
    function sendPayloadToEvm(
        uint16 targetChain,
        address targetAddress,
        bytes memory payload,
        uint256 receiverValue,
        uint256 gasLimit,
        uint16 refundChain,
        address refundAddress
    ) external payable returns (uint64 sequence) {
        emit MessageSent(targetChain, targetAddress, payload, receiverValue, gasLimit);
        
        // Simulate successful delivery by calling the receiver directly
        if (targetAddress.code.length > 0) {
            simulateMessageDelivery(targetAddress, payload, receiverValue);
        }
        
        return 1;
    }
    
    // Allow the mock to receive ether
    receive() external payable {}
    
    function simulateMessageDelivery(
        address receiver,
        bytes memory payload,
        uint256 receiverValue
    ) internal {
        // Try to extract sender address from payload
        bytes32 sourceAddress;
        uint16 sourceChain = 13; // Mock source chain
        
        // Try different payload formats
        if (payload.length >= 32) {
            try this.tryDecodeStandardPayload(payload) returns (address sender) {
                sourceAddress = bytes32(uint256(uint160(sender)));
            } catch {
                try this.tryDecodeOnboardingPayload(payload) returns (address sender) {
                    sourceAddress = bytes32(uint256(uint160(sender)));
                } catch {
                    // Fallback to a default address
                    sourceAddress = bytes32(uint256(uint160(address(this))));
                }
            }
        } else {
            sourceAddress = bytes32(uint256(uint160(address(this))));
        }
        
        bytes32 deliveryHash = keccak256("mock_delivery");
        bytes[] memory additionalVaas = new bytes[](0);
        
        // Call the receiver with mock parameters
        (bool success, ) = receiver.call{value: receiverValue}(
            abi.encodeWithSignature(
                "receiveWormholeMessages(bytes,bytes[],bytes32,uint16,bytes32)",
                payload,
                additionalVaas,
                sourceAddress,
                sourceChain,
                deliveryHash
            )
        );
        
        require(success, "Mock delivery failed");
    }
    
    function tryDecodeStandardPayload(bytes memory payload) external pure returns (address sender) {
        (sender, , ) = abi.decode(payload, (address, address, bytes));
    }
    
    function tryDecodeOnboardingPayload(bytes memory payload) external pure returns (address sender) {
        (sender, , ) = abi.decode(payload, (address, string, string));
    }
}