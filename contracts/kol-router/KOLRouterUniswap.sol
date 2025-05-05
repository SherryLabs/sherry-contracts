// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./KOLSwapRouterBase.sol";
import "./interfaces/IUniversalRouter.sol";

contract KOLRouterUniswap is KOLSwapRouterBase {
    constructor(
        address _kolAddress,
        address _universalRouter,
        address _factoryAddress
    ) KOLSwapRouterBase(_kolAddress, _universalRouter, _factoryAddress) {}

    function execute(
        bytes calldata commands,
        bytes[] calldata inputs,
        uint256 deadline
    ) external payable verifyFee(msg.value) {
        uint256 valueToSend = msg.value - fixedFeeAmount;

        IUniversalRouter(dexRouter).execute{value: valueToSend}(
            commands,
            inputs,
            deadline
        );

        emit SwapExecuted(kolAddress, msg.sender, fixedFeeAmount);
    }

    receive() external payable {}
}