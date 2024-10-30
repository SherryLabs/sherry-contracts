// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "lib/wormhole-solidity-sdk/src/TokenBase.sol";
import "lib/wormhole-solidity-sdk/src/interfaces/IERC20.sol";

contract SL1TokenReceiver is TokenReceiver {
    constructor(
        address _wormholeRelayer,
        address _tokenBridge,
        address _wormhole
    ) TokenBase(_wormholeRelayer, _tokenBridge, _wormhole) {}

    function receivePayloadAndTokens(
        bytes memory _payload,
        TokenReceived[] memory _tokens,
        bytes32 _sourceAddress,
        uint16 _sourceChain,
        bytes32
    )
        internal
        override
        onlyWormholeRelayer
        isRegisteredSender(_sourceChain, _sourceAddress)
    {
        require(_tokens.length == 1, "Only one token is allowed");
        address to = abi.decode(_payload, (address));

        IERC20(_tokens[0].tokenAddress).transfer(to, _tokens[0].amount);
    }
}
