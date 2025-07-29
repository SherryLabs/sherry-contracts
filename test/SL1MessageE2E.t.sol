// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../contracts/wormhole/SL1MessageSender.sol";
import "../contracts/wormhole/SL1MessageReceiver.sol";
import "./mocks/SimpleWormholeRelayerMock.sol";

contract SL1MessageE2ETest is Test {
    SL1MessageSender public sender;
    SL1MessageReceiver public receiver;
    SimpleWormholeRelayerMock public mockRelayer;
    
    address public owner;
    address public user;
    MockTargetContract public targetContract;
    
    uint16 constant SOURCE_CHAIN = 13;
    uint16 constant TARGET_CHAIN = 14;
    
    function setUp() public {
        owner = address(this);
        user = makeAddr("user");
        
        // Deploy mock relayer
        mockRelayer = new SimpleWormholeRelayerMock();
        
        // Deploy sender and receiver
        sender = new SL1MessageSender(address(mockRelayer), SOURCE_CHAIN);
        receiver = new SL1MessageReceiver(address(mockRelayer));
        
        // Deploy target contract
        targetContract = new MockTargetContract();
        
        // Register sender in receiver - need to register all potential senders
        // In real Wormhole, this would be the sender contract address from source chain
        bytes32 userSenderAddress = bytes32(uint256(uint160(user)));
        receiver.setRegisteredSender(SOURCE_CHAIN, userSenderAddress);
        
        // Fund user and mock relayer
        vm.deal(user, 10 ether);
        vm.deal(address(mockRelayer), 10 ether);
    }
    
    function testEndToEndMessage() public {
        uint256 initialValue = targetContract.value();
        uint256 newValue = 42;
        
        // Prepare function call
        bytes memory encodedCall = abi.encodeWithSignature("setValue(uint256)", newValue);
        
        // Send message
        vm.prank(user);
        sender.sendMessage{value: 0.1 ether}(
            TARGET_CHAIN,
            address(receiver),
            address(targetContract),
            encodedCall,
            800_000,
            0
        );
        
        // Verify the target contract was called
        assertEq(targetContract.value(), newValue);
        assertNotEq(targetContract.value(), initialValue);
    }
    
    function testMessageWithValueTransfer() public {
        uint256 transferAmount = 0.5 ether;
        bytes memory encodedCall = abi.encodeWithSignature("receiveValue()");
        
        uint256 initialBalance = address(targetContract).balance;
        
        vm.prank(user);
        sender.sendMessage{value: 1 ether}(
            TARGET_CHAIN,
            address(receiver),
            address(targetContract),
            encodedCall,
            800_000,
            transferAmount
        );
        
        // Verify value was transferred
        assertEq(address(targetContract).balance, initialBalance + transferAmount);
    }
    
    function testRevertWhenExecutionFails() public {
        // Test failed execution and refund
        bytes memory encodedCall = abi.encodeWithSignature("revertFunction()");
        
        vm.prank(user);
        sender.sendMessage{value: 1 ether}(
            TARGET_CHAIN,
            address(receiver),
            address(targetContract),
            encodedCall,
            800_000,
            0.1 ether
        );
        
        // In our mock, failed execution should emit FunctionCallError event
        // and attempt refund (though refund might also fail in some cases)
    }
    
    function testUnregisteredSender() public {
        // Deploy new sender that's not registered
        SL1MessageSender unauthorizedSender = new SL1MessageSender(
            address(mockRelayer), 
            SOURCE_CHAIN
        );
        
        bytes memory encodedCall = abi.encodeWithSignature("setValue(uint256)", 42);
        
        // In our mock, this will fail during delivery simulation
        // because the sender is not registered in the receiver
        vm.expectRevert("Mock delivery failed");
        unauthorizedSender.sendMessage{value: 0.1 ether}(
            TARGET_CHAIN,
            address(receiver),
            address(targetContract),
            encodedCall,
            800_000,
            0
        );
    }
}

contract MockTargetContract {
    uint256 public value;
    
    event ValueSet(uint256 newValue);
    event ValueReceived(uint256 amount);
    
    function setValue(uint256 _value) external {
        value = _value;
        emit ValueSet(_value);
    }
    
    function receiveValue() external payable {
        emit ValueReceived(msg.value);
    }
    
    function revertFunction() external pure {
        revert("Intentional revert");
    }
    
    receive() external payable {
        emit ValueReceived(msg.value);
    }
}