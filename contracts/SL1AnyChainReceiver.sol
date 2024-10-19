pragma solidity ^0.8.25;

import {ITeleporterReceiver} from "../teleporter/contracts/teleporter/ITeleporterReceiver.sol";

contract SL1AnyChainReceiver {}
/*
contract SL1AnyChainReceiver is ITeleporterReceiver {

    function receiverTeleporterMessage(bytes calldata, address, bytes calldata message) external override {
        
    }
}
*/