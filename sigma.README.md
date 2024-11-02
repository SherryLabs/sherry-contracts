# Sherry Links Smart Contracts 

The following address has been used to deploy the smart contracts `0xf970be6543cd20ff1f7570959949e31fa16fba7b` 🏦

## 📑 Index

## 🚀 SL1MessageSender.sol

This contract is used to send any message to any chain supported by wormhole. It allows executing any function on any of these chains.

### 🔧 Main Function - `sendMessage`

```solidity
  function sendMessage(
    uint16 _targetChain,
    address _targetAddress,
    address _contractToBeCalled,
    bytes memory _encodedFunctionCall,
    uint256 _gasLimitgit
  ) external payable {}
```

#### 📜 Function Description

The `sendMessage` function allows sending an encoded message through a cross-chain protocol to execute a specific function on a destination contract on another blockchain.

#### 📊 Parameters

- `uint16 _targetChain`: The identifier of the target blockchain. This identifier is specific to the cross-chain protocol being used.
- `address _targetAddress`: The address of the contract on the destination blockchain where the function will be executed.
- `address _contractToBeCalled`: The address of the contract on the destination blockchain that will receive the message.
- `bytes memory _encodedFunctionCall`: The encoded function call that includes the function signature and parameters. This call should be encoded using `abi.encodeWithSignature` or `abi.encodePacked`.
- `uint256 _gasLimit`: The gas limit allocated for the function execution on the destination blockchain. This value should be sufficient to cover the execution cost of the function.

#### 🛠️ Usage Example

```solidity
uint16 targetChain = 1; // Example chain ID
address targetAddress = 0x1234567890abcdef1234567890abcdef12345678;
address contractToBeCalled = 0xabcdefabcdefabcdefabcdefabcdefabcdefabcdef;
bytes memory encodedFunctionCall = abi.encodeWithSignature("someFunction(uint256,address)", 42, 0xabcdefabcdefabcdefabcdefabcdefabcdefabcdef);
uint256 gasLimit = 200000;

sendMessage(targetChain, targetAddress, contractToBeCalled, encodedFunctionCall, gasLimit);
```

In this example, a message is sent to execute the someFunction function on the destination contract with the parameters 42 and 0xabcdefabcdefabcdefabcdefabcdefabcdef. The message is sent to the destination contract address specified by targetAddress on the destination blockchain specified by targetChain with a gas limit of 200000.

This approach allows flexible and dynamic communication between contracts on different blockchains, facilitating cross-chain interoperability.

## 📜 Contract Addresses

### ⚙️ Configuration for Wormhole SIGMA SPRINT

Sherry ERC-20 Token following the `PeerToken` [model](https://github.com/wormhole-foundation/example-ntt-token/blob/main/README.md). Contracts used for this example come from the wormhole example [repo](https://github.com/wormhole-foundation/example-ntt-token/blob/main/README.md).

| ✅ Contract Name | :spiral_notepad: Address                                      | :chains: Chain  |
|---------------|----------------------------------------------|--------|
| `SherryPeerToken`     | `0x528B3020621d0Bff4627483d34bF4dE21afaF08E`   | `Avalanche Fuji`    |
| `SherryPeerToken`     | `0x075f8Af6c27a570b4c8A94BaE72f878fc98721a5`   | `Celo Alfajores`    | 

### 💸 Native Token Transfers (NTT) Configuration

In order to perform `Sherry Token` transfers using `NTT`, the `Ntt Manager` and `Transceiver` contracts must be deployed. To achieve this, the `Wormhole CLI` has been used following the steps in the [documentation](https://wormhole.com/docs/build/contract-integrations/native-token-transfers/deployment-process/deploy-to-evm/#deploy-ntt).

The repository with detailed information and configuration of the following contracts can be found in the [corresponding repository](https://github.com/SherryLabs/sherry-ntt-config).

| Contract Name | Address | Chain | Chain ID |
|---------------|---------|-------|-------------|
| `Ntt Manager`|`0xeBa6f576e5c2F772F0EBF48fC788375846B64531`|`Avalanche Fuji`| 6 |
|`Transceiver`|`0x70a22a7567105B76CB8Eb29d4E9bb8d10510E2cD`|`Avalanche Fuji`| 6 |

| Contract Name | Address | Chain | Chain ID |
|---------------|---------|-------|-------------|
| `Ntt Manager`|`0x89b1a692A61Ad02519E49c85462a35CDa1987EF4`|`Celo Alfajores`| 14 |
|`Transceiver`|`0xe731274C25B51B1217093D5Cf7bc1C36cADeF508`|`Celo Alfajores`| 14 |

### 📡 Message Sender and Receiver Contracts

The sender contract is used to send cross-chain messages using Wormhole.

| ✅ Contract Name | :spiral_notepad: Address  | :chains: Chain  |
|---------------|----------------------------------------------|--------|
| `SL1MessageSender`     | `0x4f34C7119c1C918c606792D8a481D915D845DD2E`   | `Avalanche Fuji`    |

The receiver contract is used to receive cross-chain messages and trigger execution using the SDK.

| ✅ Contract Name | :spiral_notepad: Address    | :chains: Chain  |
|---------------|----------------------------------------------|--------|
| `SL1AnyChainReceiver`     | `0x76c3cF8521b5B1cfddF6c17E7bBe1d3f4dC9Ee14`   | `Celo Alfajores`    | 

### 🛠️ Contract - Examples

These contracts are used to showcase what you can build with our SDK.

Greeting contract to simply set a new greeting and counter.

| Contract Name | Address                                      | Chain  |
|---------------|----------------------------------------------|--------|
| `Greeting`     | ``   | `Celo Alfajores`    |

Capture the Flag to showcase a simple cross-chain game

| Contract Name | Address                                      | Chain  |
|---------------|----------------------------------------------|--------|
| `CaptureFlag`     | ``   | `Celo Alfajores`    |

NFTGunzilla to mint an NFT representing a weapon in the Gunzilla Game.

| Contract Name | Address                                      | Chain  |
|---------------|----------------------------------------------|--------|
| `NFTGunzilla`     | ``   | `Celo Alfajores`    |

## 📝 Addresses in WH HEX format

Information related to addresses in Wormhole HEX Format in order to receive messages in destination chain successfully

| Contract Name | Data | Type |
|---------|----|------|
| `SL1MessageSender` | `` | hex
| `` | `` | hex

