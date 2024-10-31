# SL1 Smart Contracts 

The following addres has been used to deploy the smart contracts `0xf970be6543cd20ff1f7570959949e31fa16fba7b`

## Índice

- [SL1MessageSender.sol](#sl1messagesendersol)
- [SL1.sol](#sl1sol)
- [SL1Sender.sol](#sl1sendersol)
  - [Main Function - `sendMessage`](#main-function---sendmessage)
  - [Function Description](#function-description)
  - [Parameters](#parameters)
  - [Usage Example](#usage-example)
- [Contract Addresses](#contract-addresses)
  - [Configuration for Wormhole SIGMA SPRINT](#configuration-for-wormhole-sigma-sprint)
  - [Configuration for Avalanche Summit Hackathon](#configuration-for-avalanche-summit-hackathon)
- [Contract - Examples](#contract---examples)
- [Chain Data](#chain-data)

## SL1MessageSender.sol

## SL1.sol

Under dev: Contract to call functions in Avalanche. This contract is deployed in Avalanche in order to interact with contracts deployed in Avalanche. ICM is not needed.

## SL1Sender.sol

This contract is used to send any message to any L1. It allows executing any function on any of these L1s.

### Main Function - `sendMessage`

```solidity
    function sendMessage(
        address _destinationContract,
        bytes calldata _encodedFunctionCall,
        address _destinationAddress,
        bytes32 _destinationChain,
        uint256 _gasLimit
    ) public {}
```

#### Function Description

The `sendMessage` function allows sending an encoded message through a cross-chain protocol to execute a specific function on a destination contract on another blockchain.

#### Parameters

- `address _destinationContract`: The address of the contract on the destination blockchain where the function will be executed.
- `bytes calldata _encodedFunctionCall`: The encoded function call that includes the function signature and parameters. This call should be encoded using abi.encodeWithSignature or abi.encodePacked.
- `address _destinationAddress`: The address of the contract on the destination blockchain that will receive the message.
- `bytes32 _destinationChain`: The identifier of the destination blockchain. This identifier is specific to the cross-chain protocol being used.
- `uint256 _gasLimit`: The gas limit allocated for the function execution on the destination blockchain. This value should be sufficient to cover the execution cost of the function.

#### Usage Example

```solidity
address destinationContract = 0x1234567890abcdef1234567890abcdef12345678;
bytes memory encodedFunctionCall = abi.encodeWithSignature("someFunction(uint256,address)", 42, 0xabcdefabcdefabcdefabcdefabcdefabcdef);
address destinationAddress = 0xabcdefabcdefabcdefabcdefabcdefabcdefabcdef;
bytes32 destinationChain = 0xabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdef;
uint256 gasLimit = 200000;

SL1Sender.sendMessage(destinationContract, encodedFunctionCall, destinationAddress, destinationChain, gasLimit);
```

In this example, a message is sent to execute the `someFunction` function on the destination contract with the parameters `42` and `0xabcdefabcdefabcdefabcdefabcdefabcdef`. The message is sent to the destination contract address specified by `destinationAddress` on the destination blockchain specified by `destinationChain` with a gas limit of `200000`.

This approach allows flexible and dynamic communication between contracts on different blockchains, facilitating cross-chain interoperability.

## Contract Addresses

### Configuration for Wormhole SIGMA SPRINT

Sherry ERC-20 Token following the `PeerToken` (model)[https://github.com/wormhole-foundation/example-ntt-token/blob/main/README.md]. Contracts used for this example come from the wormhole example (repo)[https://github.com/wormhole-foundation/example-ntt-token/blob/main/README.md].

| Contract Name | Address                                      | Chain  |
|---------------|----------------------------------------------|--------|
| `SherryPeerToken`     | `0x528B3020621d0Bff4627483d34bF4dE21afaF08E`   | `Avalanche Fuji`    |
| `SherryPeerToken`     | `0x075f8Af6c27a570b4c8A94BaE72f878fc98721a5`   | `Celo Alfajores`    | 

### Configuration for Avalanche Summit Hackathon

The sender contract is used to send cross-chain messages using Teleporter/ICM.

| ✅ Contract Name | :spiral_notepad: Address                                      | :chains: Chain  |
|---------------|----------------------------------------------|--------|
| `SL1Sender`     | **`0x4f34C7119c1C918c606792D8a481D915D845DD2E`**   | `sL1`    |
| `SL1Sender`     | `0xC88845285454F59849537e5f911738ccD05f9681`   | `Dispatch L1`    | 
| `SL1Sender`     | `0x59c80C541F6c065fb56EF25F87b1Fa8b58BEFaC1`   | `Fuji`    |

The receiver contract is used to receive cross-chain messages and trigger execution using the SDK.

| Contract Name | Address                                      | Chain  |
|---------------|----------------------------------------------|--------|
| `SL1AnyChainReceiver`     | `0x76c3cF8521b5B1cfddF6c17E7bBe1d3f4dC9Ee14`   | `Dispatch L1`    | 
| `SL1AnyChainReceiver`     | `0x0fD3820e2255AA876797BBACE02c519f9B0A824f`   | `Fuji`    |

### Contract - Examples

These contracts are used to showcase what you can build with our SDK.

Greeting contract to simply set a new greeting and counter.

| Contract Name | Address                                      | Chain  |
|---------------|----------------------------------------------|--------|
| `Greeting`     | `0x212b6dAC5cB691Bc4AD5228627BC3A1Ab4C7A5b6`   | `Dispatch L1`    |
| `Greeting`     | `0x2b9c3919846d45aec67aEc9e59616a23fdb53f96`   | `Fuji`    |

NFTGunzilla to mint an NFT representing a weapon in the Gunzilla Game.

| Contract Name | Address                                      | Chain  |
|---------------|----------------------------------------------|--------|
| `NFTGunzilla`     | `0x4A38545e805e62532282b0f04B200019A79a790d`   | `Dispatch L1`    |

CCIP sender to send USDC using our SDK and Chainlink CCIP.

| Contract Name | Address                                      | Chain  |
|---------------|----------------------------------------------|--------|
| `CCIPSender`     | `0xc88636a35047cF10E74036DB8BD444Fe3eA276BD`   | `Fuji`    |

## Chain Data

Information related to L1s used in Sherry.

| L1 Name | ID | Type |
|---------|----|------|
| `Dispatch` | `0x9f3be606497285d0ffbb5ac9ba24aa60346a9b1812479ed66cb329f394a4b1c7` | hex
| `C-chain` | `0xdb76a6c20fd0af4851417c79c479ebb1e91b3d4e7e57116036d203e3692a0856` | hex

