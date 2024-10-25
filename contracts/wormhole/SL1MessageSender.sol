// SPDX-license-Identifier: MIT
pragma solidity ^0.8.25;

import "../../lib/wormhole-solidity-sdk/src/interfaces/IWormholeRelayer.sol";

contract SL1MessageSender {
    IWormholeRelayer public s_wormholeRelayer;
    address public owner;
    uint256 public GAS_LIMIT = 300_000;

    constructor(address _wormholeRelayer) {
        s_wormholeRelayer = IWormholeRelayer(_wormholeRelayer);
        owner = msg.sender;
    }

    function quoteCrossChainCost(
        uint16 _targetChain,
        uint256 _gasLimit
    ) public view returns (uint256 cost) {
        (cost, ) = s_wormholeRelayer.quoteEVMDeliveryPrice(
            _targetChain,
            0,
            _gasLimit
        );
    }

    function encodeMessage(
        address _contractToBeCalled,
        bytes memory _encodedFunctionCall
    ) public view returns (bytes memory) {
        return
            abi.encode(_contractToBeCalled, msg.sender, _encodedFunctionCall);
    }

    function sendMessage(
        uint16 _targetChain,
        address _targetAddress,
        address _contractToBeCalled,
        bytes memory _encodedFunctionCall, 
        uint256 _gasLimit
    ) external payable {
        bytes memory encodedData = encodeMessage(
            _contractToBeCalled,
            _encodedFunctionCall
        );
        uint256 cost = quoteCrossChainCost(_targetChain, _gasLimit);
        s_wormholeRelayer.sendPayloadToEvm{value: cost}(
            _targetChain,
            _targetAddress,
            encodedData,
            0,
            _gasLimit
        );
    }

    function setGasLimit(uint256 _gasLimit) external onlyOwner {
        GAS_LIMIT = _gasLimit;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}
