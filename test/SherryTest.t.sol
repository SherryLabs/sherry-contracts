// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../contracts/Sherry.sol";
import "../contracts/mock/MockContract.sol";

contract SherryTest is Test {
    Sherry public sherry;
    MockContract public mockContract;
    address public owner;
    address public user;

    function setUp() public {
        owner = address(this);
        user = address(0x1);
        sherry = new Sherry();
        mockContract = new MockContract();
        vm.deal(user, 100 ether);
    }

    function testPauseUnpause() public {
        sherry.pause();
        assertTrue(sherry.paused());

        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 123);
        vm.expectRevert(0xd93c0665);

        sherry.execFunction(address(mockContract), data);

        sherry.unpause();
        assertFalse(sherry.paused());

        sherry.execFunction(address(mockContract), data);
        assertEq(mockContract.value(), 123);
    }

    function testOnlyOwnerCanPause() public {
        vm.prank(user);
        vm.expectRevert();
        sherry.pause();
    }

    function testMinDataLength() public {
        bytes memory invalidData = new bytes(3);
        vm.expectRevert("Invalid function call data");
        sherry.execFunction(address(mockContract), invalidData);
    }

    function testZeroAddress() public {
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 123);
        vm.expectRevert("Invalid contract address");
        sherry.execFunction(address(0), data);
    }

    function testExecFunction() public {
        bytes memory encodedFunctionCall = abi.encodeWithSignature(
            "setValue(uint256)",
            42
        );
        sherry.execFunction(address(mockContract), encodedFunctionCall);
        assertEq(mockContract.value(), 42);
    }

    function testFailedFunctionEmitsEvent() public {
        bytes memory data = abi.encodeWithSignature("revertFunction()");

        
        vm.expectEmit(true, true, true, true);
        emit Sherry.FunctionFailed(
            address(mockContract),
            data,
            "Function reverted"
        );
        sherry.execFunction(address(mockContract), data);
    }

    function testDirectEthTransfer() public {
        vm.expectRevert("Direct ETH transfers not allowed");
        (bool success, ) = address(sherry).call{value: 1 ether}("");
        assertFalse(success);
    }

    function testPausedExecution() public {
        sherry.pause();
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 123);
        vm.expectRevert();
        sherry.execFunction(address(mockContract), data);
    }

    function testComplexRevertMessage() public {
        bytes memory data = abi.encodeWithSignature("complexRevert()");
        vm.expectRevert("Transaction reverted silently");
        sherry.execFunction(address(mockContract), data);
    }

    function testEventEmission() public {
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 123);

        // Expect event to be emitted
        vm.expectEmit(true, true, false, true);
        emit Sherry.FunctionExecuted(address(mockContract), data);

        // Execute function
        sherry.execFunction(address(mockContract), data);
    }

    function testExecFunctionRevert() public {
        bytes memory encodedFunctionCall = abi.encodeWithSignature(
            "revertFunction()"
        );
        vm.expectRevert("Function reverted");
        sherry.execFunction(address(mockContract), encodedFunctionCall);
    }
}
