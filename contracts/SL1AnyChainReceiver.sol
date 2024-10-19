pragma solidity ^0.8.25;

import {ITeleporterReceiver} from "../teleporter/contracts/teleporter/ITeleporterReceiver.sol";

contract SL1AnyChainReceiver is TeleporterReceiver {

    function receiverTeleporterMessage(bytes, address, bytes calldata message) external override {
        
    }
}