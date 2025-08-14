//SPDX-License-Idenfgitifier: MIT
pragma solidity ^0.8.25;

import "lib/wormhole-solidity-sdk/src/interfaces/IWormholeRelayer.sol";
import "forge-std/Test.sol";
import "../contracts/wormhole/SL1MessageSender.sol";

contract SL1MessagesenderTest is Test {
    SL1MessageSender public s_sender;
    address public user;

    function setUp() public {
        s_sender = new SL1MessageSender(address(this), 13);
        user = address(0x123);
        vm.deal(user, 1 ether);
    }

    function testSendMessageNegativeValue() public {
        uint16 _targetChain = 14;
        address _receiverAddress = address(0x3);
        address _contractToBeCalled = address(0x2);
        bytes memory _encodedFunctionCall = abi.encodeWithSignature(
            "setValue(uint256)",
            42
        );
        uint256 _gasLimit = 800_000;
        uint256 _receiverValue = 1;
        uint256 _cost = 10;//s_sender.quoteCrossChainCost(_targetChain, _receiverValue, _gasLimit);

        vm.expectRevert();
        s_sender.sendMessage{value: 0}(
            _targetChain,
            _receiverAddress,
            _contractToBeCalled,
            _encodedFunctionCall,
            _gasLimit,
            _receiverValue
        );
    }

    function testTransferOwnership() public {
        address newOwner = address(0x456);
        
        // Verify current owner
        assertEq(s_sender.owner(), address(this));
        
        // Transfer ownership
        vm.expectEmit(true, true, false, true);
        emit SL1MessageSender.OwnershipTransferred(address(this), newOwner);
        s_sender.transferOwnership(newOwner);
        
        // Verify new owner
        assertEq(s_sender.owner(), newOwner);
        
        // Test that only new owner can call onlyOwner functions
        vm.prank(newOwner);
        s_sender.setGasLimit(1_000_000);
        
        // Old owner should not be able to call onlyOwner functions
        vm.expectRevert("Only the owner can call this function");
        s_sender.setGasLimit(500_000);
    }
    
    function testTransferOwnershipRevertZeroAddress() public {
        vm.expectRevert(abi.encodeWithSelector(SL1MessageSender.OwnableInvalidOwner.selector, address(0)));
        s_sender.transferOwnership(address(0));
    }
    
    function testTransferOwnershipOnlyOwner() public {
        address nonOwner = address(0x789);
        address newOwner = address(0x456);
        
        vm.prank(nonOwner);
        vm.expectRevert("Only the owner can call this function");
        s_sender.transferOwnership(newOwner);
    }
}
