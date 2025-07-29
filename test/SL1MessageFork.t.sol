// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../contracts/wormhole/SL1MessageSender.sol";
import "../contracts/wormhole/SL1MessageReceiver.sol";

contract SL1MessageForkTest is Test {
    SL1MessageSender public sender;
    SL1MessageReceiver public receiver;
    
    // Wormhole addresses on mainnet/testnet
    address constant WORMHOLE_RELAYER_AVALANCHE = 0x27428DD2d3DD32A4D7f7C497eAaa23130d894911;
    address constant WORMHOLE_RELAYER_ETHEREUM = 0x27428DD2d3DD32A4D7f7C497eAaa23130d894911;
    
    function setUp() public {
        // Fork Avalanche mainnet for testing
        uint256 avalancheFork = vm.createFork("https://api.avax.network/ext/bc/C/rpc");
        vm.selectFork(avalancheFork);
        
        // Deploy contracts with real Wormhole relayer
        sender = new SL1MessageSender(WORMHOLE_RELAYER_AVALANCHE, 6); // Avalanche chain ID
        receiver = new SL1MessageReceiver(WORMHOLE_RELAYER_AVALANCHE);
        
        // Register sender
        bytes32 senderAddress = bytes32(uint256(uint160(address(sender))));
        receiver.setRegisteredSender(6, senderAddress);
    }
    
    function testQuoteCrossChainCost() public {
        uint256 cost = sender.quoteCrossChainCost(2, 0, 800_000); // Ethereum
        assertGt(cost, 0, "Cost should be greater than 0");
        console.log("Cross-chain cost:", cost);
    }
    
    function testSendMessageGasLimitValidation() public {
        // Test gas limit validation with real Wormhole contracts
        uint256 cost = sender.quoteCrossChainCost(2, 0, 800_000);
        vm.deal(address(this), cost + 1 ether);
        
        bytes memory encodedCall = abi.encodeWithSignature("setValue(uint256)", 42);
        
        // Test that gas limit validation works
        vm.expectRevert("Gas limit exceeds the maximum limit");
        sender.sendMessage{value: cost}(
            2, // Ethereum  
            address(receiver),
            address(0x123),
            encodedCall,
            900_000, // Exceeds the 800k limit
            0
        );
    }
    
    receive() external payable {}
}