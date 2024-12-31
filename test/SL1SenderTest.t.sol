//SPDX-License-Idenfgitifier: MIT
pragma solidity ^0.8.25;

import "lib/wormhole-solidity-sdk/src/interfaces/IWormholeRelayer.sol";
import "forge-std/Test.sol";
import "../contracts/wormhole/SL1MessageSender.sol";

contract SL1MessagesenderTest is Test {
    SL1MessageSender public s_sender;
    address public user;

    function setUp() public {
        s_sender = new SL1MessageSender(address(this));
        user = address(0x123);
        vm.deal(user, 1 ether);
    }
}