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
    uint16 public constant ORIGIN_CHAIN = 6; // Avalanche WH chain ID

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
    constructor(address _wormholeRelayer) {
        s_wormholeRelayer = IWormholeRelayer(_wormholeRelayer);
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
        uint256 _gasLimit
    ) public view returns (uint256 cost) {
        (cost, ) = s_wormholeRelayer.quoteEVMDeliveryPrice(
            _targetChain,
            0,
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
            abi.encode(_contractToBeCalled, msg.sender, _encodedFunctionCall);
    }

    /**
     * @notice Sends a cross-chain message with a refund option.
     * @param _targetChain The target chain ID.
     * @param _targetAddress The address on the target chain to send the message to.
     * @param _contractToBeCalled The address of the contract to be called on the target chain.
     * @param _encodedFunctionCall The encoded function call data.
     * @param _gasLimit The gas limit for the cross-chain message.
     */
    function sendMessageWithRefund(
        uint16 _targetChain,
        address _targetAddress,
        address _contractToBeCalled,
        bytes memory _encodedFunctionCall,
        uint256 _gasLimit
    ) external payable {
        require(_gasLimit <= GAS_LIMIT, "Gas limit exceeds the maximum limit");
        bytes memory encodedData = encodeMessage(
            _contractToBeCalled,
            _encodedFunctionCall
        );
        uint256 cost = quoteCrossChainCost(_targetChain, _gasLimit);
        uint256 nativeValue = msg.value - cost;

        s_wormholeRelayer.sendPayloadToEvm{value: cost}(
            _targetChain,
            _targetAddress,
            encodedData,
            nativeValue,
            _gasLimit,
            ORIGIN_CHAIN,
            msg.sender
        );
    }

    /**
     * @notice Sends a cross-chain message.
     * @param _targetChain The target chain ID.
     * @param _targetAddress The address on the target chain to send the message to.
     * @param _contractToBeCalled The address of the contract to be called on the target chain.
     * @param _encodedFunctionCall The encoded function call data.
     * @param _gasLimit The gas limit for the cross-chain message.
     */
    function sendMessage(
        uint16 _targetChain,
        address _targetAddress,
        address _contractToBeCalled,
        bytes memory _encodedFunctionCall,
        uint256 _gasLimit
    ) external payable {
        require(_gasLimit <= GAS_LIMIT, "Gas limit exceeds the maximum limit");
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
