// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../../contracts/examples/wormhole/CaptureFlagWH.sol";

contract CaptureFlagWHTest is Test {
    CaptureFlagWH public capture;
    address public owner;
    address public player1;
    address public player2;

    function setUp() public {
        owner = address(this);
        player1 = address(0x1);
        player2 = address(0x2);
        capture = new CaptureFlagWH();
        //capture.transferOwnership(owner);
        vm.warp(10 minutes);
    }

    function testCaptureFlag() public {
        // Player 1 captures the flag
        vm.prank(player1);
        vm.deal(player1, 1 ether);
        capture.captureFlag{value: 0.1 ether}(player1);

        //assertEq(captureFlag.flagHolder(), player1);
        //assertEq(captureFlag.flagCaptureTime(), block.timestamp);
    }

    function testCaptureFlagCooldown() public {
        // Player 1 captures the flag
        vm.prank(player1);
        vm.deal(player1, 1 ether);
        capture.captureFlag{value: 0.1 ether}(player1);

        // Fast forward time by 59 seconds
        vm.warp(block.timestamp + 59 seconds);

        // Player 2 tries to capture the flag but fails due to cooldown
        vm.prank(player2);
        vm.deal(player2, 1 ether);
        vm.expectRevert("Flag can only be captured after 1 minute");
        capture.captureFlag{value: 0.1 ether}(player2);
    }

    function testWithdraw() public {
        // Send some Ether to the contract
        vm.deal(address(capture), 1 ether);

        // Withdraw the Ether
        uint256 initialBalance = owner.balance;
        capture.withdraw();

        assertEq(address(capture).balance, 0);
        assertEq(owner.balance, initialBalance + 1 ether);
    }

    function testParticipationCooldown() public {
        // Player 1 captures the flag
        vm.prank(player1);
        vm.deal(player1, 1 ether);
        capture.captureFlag{value: 0.1 ether}(player1);

        // Fast forward time by 5 minutes
        vm.warp(block.timestamp + 5 minutes);

        // Player 1 tries to capture the flag again but fails due to cooldown
        vm.prank(player1);
        vm.expectRevert("Wait 10 minutes before participating again");
        capture.captureFlag{value: 0.1 ether}(player1);
    }

    function testSetFlagPrice() public {
        uint256 newPrice = 0.2 ether;

        // Only owner can set the flag price
        vm.prank(player1);
        vm.expectRevert("Only owner");
        capture.setFlagPrice(newPrice);

        // Owner sets the flag price
        capture.setFlagPrice(newPrice);
        assertEq(capture.flagPrice(), newPrice);
    }

    fallback() external payable {}
}