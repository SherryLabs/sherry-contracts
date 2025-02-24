// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "lib/wormhole-solidity-sdk/src/interfaces/IWormholeRelayer.sol";

/**
 * @title SL1MessageSender
 * @dev This contract allows sending cross-chain messages using the Wormhole Relayer.
 */
contract SL1MessageSender {
    IWormholeRelayer public s_wormholeRelayer;
    address public owner;
    uint256 public GAS_LIMIT = 800_000;
    uint16 public immutable ORIGIN_CHAIN; // 14 - Avalanche WH chain ID

    event MessageSent(
        address indexed contractToBeCalled,
        bytes encodedFunctionCall,
        address destinationAddress,
        bytes32 destinationChain
    );

    /**
     * @dev Sets the Wormhole Relayer address and initializes the contract owner.
     * @param _wormholeRelayer The address of the Wormhole Relayer contract.
     */
    constructor(address _wormholeRelayer, uint16 _originChain) {
        s_wormholeRelayer = IWormholeRelayer(_wormholeRelayer);
        ORIGIN_CHAIN = _originChain;
        owner = msg.sender;
    }

    /**
     * @notice Quotes the cost of sending a cross-chain message.
     * @param _targetChain The target chain ID.
     * @param _gasLimit The gas limit for the cross-chain message.
     * @return cost The quoted cost for sending the message.
     */
    function quoteCrossChainCost(
        uint16 _targetChain,
        uint256 _receiverValue,
        uint256 _gasLimit
    ) public view returns (uint256 cost) {
        (cost, ) = s_wormholeRelayer.quoteEVMDeliveryPrice(
            _targetChain,
            _receiverValue,
            _gasLimit
        );
    }

    /**
     * @notice Encodes the message to be sent cross-chain.
     * @param _contractToBeCalled The address of the contract to be called on the target chain.
     * @param _encodedFunctionCall The encoded function call data.
     * @return The encoded message.
     */
    function encodeMessage(
        address _contractToBeCalled,
        bytes memory _encodedFunctionCall
    ) public view returns (bytes memory) {
        return
            abi.encode(msg.sender, _contractToBeCalled, _encodedFunctionCall);
    }

    /**
     * @notice Sends a cross-chain message with a refund option.
     * @param _targetChain The target chain ID.
     * @param _receiverAddress The address on the target chain - WH SL1 Message Receiver.
     * @param _contractToBeCalled The address of the contract to be called on the target chain.
     * @param _encodedFunctionCall The encoded function call data.
     * @param _gasLimit The gas limit for the cross-chain message.
     */
    function sendMessage(
        uint16 _targetChain,
        address _receiverAddress,
        address _contractToBeCalled,
        bytes memory _encodedFunctionCall,
        uint256 _gasLimit,
        uint256 _receiverValue
    ) external payable {
        require(_gasLimit <= GAS_LIMIT, "Gas limit exceeds the maximum limit");
        bytes memory encodedData = encodeMessage(
            _contractToBeCalled,
            _encodedFunctionCall
        );

        uint256 cost = quoteCrossChainCost(
            _targetChain,
            _receiverValue,
            _gasLimit
        );
        require(msg.value >= cost, "Insufficient funds to send the message");

        s_wormholeRelayer.sendPayloadToEvm{value: cost}(
            _targetChain,
            _receiverAddress,
            encodedData,
            _receiverValue,
            _gasLimit,
            ORIGIN_CHAIN,
            msg.sender
        );
    }

    /**
     * @notice Sets the gas limit for cross-chain messages.
     * @param _gasLimit The new gas limit.
     */
    function setGasLimit(uint256 _gasLimit) external onlyOwner {
        GAS_LIMIT = _gasLimit;
    }

    /**
     * @dev Modifier to restrict function access to the contract owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}
