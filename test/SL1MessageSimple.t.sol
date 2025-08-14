// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../contracts/wormhole/SL1MessageSender.sol";
import "../contracts/wormhole/SL1MessageReceiver.sol";

contract SL1MessageSimpleTest is Test {
    SL1MessageSender public sender;
    SL1MessageReceiver public receiver;
    MockWormholeRelayerSimple public mockRelayer;
    
    address public user;
    MockTargetContract public targetContract;
    
    function setUp() public {
        user = makeAddr("user");
        
        // Deploy simple mock relayer
        mockRelayer = new MockWormholeRelayerSimple();
        
        // Deploy sender and receiver
        sender = new SL1MessageSender(address(mockRelayer), 13);
        receiver = new SL1MessageReceiver(address(mockRelayer));
        
        // Deploy target contract
        targetContract = new MockTargetContract();
        
        // Register user as sender
        bytes32 userAddress = bytes32(uint256(uint160(user)));
        receiver.setRegisteredSender(13, userAddress);
        
        // Fund user
        vm.deal(user, 10 ether);
    }
    
    function testQuoteCost() public {
        uint256 cost = sender.quoteCrossChainCost(14, 0, 800_000);
        assertEq(cost, 0.01 ether);
    }
    
    function testWithdrawFunctions() public {
        // Test withdraw in both contracts
        vm.deal(address(sender), 1 ether);
        vm.deal(address(receiver), 1 ether);
        
        // Verify contracts have balance
        assertEq(address(sender).balance, 1 ether);
        assertEq(address(receiver).balance, 1 ether);
        
        // Withdraw from both contracts
        sender.withdraw();
        receiver.withdraw();
        
        // Verify balances are now zero
        assertEq(address(sender).balance, 0);
        assertEq(address(receiver).balance, 0);
    }
    
    function testTransferOwnershipSender() public {
        address newOwner = makeAddr("newOwner");
        
        // Verify current owner
        assertEq(sender.owner(), address(this));
        
        // Transfer ownership
        vm.expectEmit(true, true, false, true);
        emit SL1MessageSender.OwnershipTransferred(address(this), newOwner);
        sender.transferOwnership(newOwner);
        
        // Verify new owner
        assertEq(sender.owner(), newOwner);
        
        // Test that only new owner can call onlyOwner functions
        vm.prank(newOwner);
        sender.setGasLimit(1_000_000);
        
        // Old owner should not be able to call onlyOwner functions
        vm.expectRevert("Only the owner can call this function");
        sender.setGasLimit(500_000);
    }
    
    function testTransferOwnershipSenderRevertZeroAddress() public {
        vm.expectRevert(abi.encodeWithSelector(SL1MessageSender.OwnableInvalidOwner.selector, address(0)));
        sender.transferOwnership(address(0));
    }
    
    function testTransferOwnershipSenderOnlyOwner() public {
        address nonOwner = makeAddr("nonOwner");
        address newOwner = makeAddr("newOwner");
        
        vm.prank(nonOwner);
        vm.expectRevert("Only the owner can call this function");
        sender.transferOwnership(newOwner);
    }
    
    function testTransferOwnershipReceiver() public {
        address newOwner = makeAddr("newOwner");
        
        // Verify current owner
        assertEq(receiver.s_registrationOwner(), address(this));
        
        // Transfer ownership
        vm.expectEmit(true, true, false, true);
        emit SL1MessageReceiver.OwnershipTransferred(address(this), newOwner);
        receiver.transferOwnership(newOwner);
        
        // Verify new owner
        assertEq(receiver.s_registrationOwner(), newOwner);
        
        // Test that only new owner can call onlyOwner functions
        vm.prank(newOwner);
        receiver.setRegisteredSender(14, bytes32(uint256(uint160(makeAddr("sender")))));
        
        // Old owner should not be able to call onlyOwner functions
        vm.expectRevert("Only the owner can call this function");
        receiver.setRegisteredSender(15, bytes32(uint256(uint160(makeAddr("sender2")))));
    }
    
    function testTransferOwnershipReceiverRevertZeroAddress() public {
        vm.expectRevert(abi.encodeWithSelector(SL1MessageReceiver.OwnableInvalidOwner.selector, address(0)));
        receiver.transferOwnership(address(0));
    }
    
    function testTransferOwnershipReceiverOnlyOwner() public {
        address nonOwner = makeAddr("nonOwner");
        address newOwner = makeAddr("newOwner");
        
        vm.prank(nonOwner);
        vm.expectRevert("Only the owner can call this function");
        receiver.transferOwnership(newOwner);
    }
    
    function testDirectReceiver() public {
        // Test receiver directly without cross-chain simulation
        bytes memory payload = abi.encode(user, address(targetContract), abi.encodeWithSignature("setValue(uint256)", 42));
        bytes[] memory additionalVaas = new bytes[](0);
        bytes32 sourceAddress = bytes32(uint256(uint160(user)));
        uint16 sourceChain = 13;
        bytes32 deliveryHash = keccak256("test");
        
        // Call receiver directly as if from Wormhole relayer
        vm.prank(address(mockRelayer));
        receiver.receiveWormholeMessages{value: 0}(
            payload,
            additionalVaas,
            sourceAddress,
            sourceChain,
            deliveryHash
        );
        
        // Verify target contract was called
        assertEq(targetContract.value(), 42);
    }
    
    // Allow test contract to receive ether
    receive() external payable {}
}

contract MockWormholeRelayerSimple {
    function quoteEVMDeliveryPrice(
        uint16,
        uint256,
        uint256
    ) external pure returns (uint256 nativePriceQuote, uint256 targetChainRefundPerGasUnused) {
        nativePriceQuote = 0.01 ether;
        targetChainRefundPerGasUnused = 0;
    }
    
    function sendPayloadToEvm(
        uint16,
        address,
        bytes memory,
        uint256,
        uint256,
        uint16,
        address
    ) external payable returns (uint64 sequence) {
        // Just emit event, don't simulate delivery for these simple tests
        return 1;
    }
}

contract MockTargetContract {
    uint256 public value;
    
    function setValue(uint256 _value) external {
        value = _value;
    }
    
    function receiveValue() external payable {
        // Can receive ether
    }
    
    function revertFunction() external pure {
        revert("Intentional revert");
    }
    
    receive() external payable {}
}