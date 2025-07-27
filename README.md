<!-- Consider adding a logo or banner image here -->
<!-- ![Sherry Logo](./assets/sherry-logo.png) -->
# Sherry Smart Contracts

## Index
- [About Sherry](#-about-sherry)
- [Installation](#-installation)
- [Contract Addresses](#-contract-addresses)
  - [Main Contract](#-main-contract---sherry)
- [Cross-Chain Interoperability](#-cross-chain-interoperability)
  - [Wormhole Integration](#-wormhole-integration)
  - [Avalanche Ecosystem Interoperability](#-avalanche-ecosystem-interoperability)
- [Example](#-example)
- [Docs](#-docs)

## About Sherry

At Sherry, we are committed to simplifying and making blockchain interactions more accessible, and have developed an SDK that allows developers to create highly versatile mini-apps. These mini-apps can execute any function of any smart contract using a simple metadata definition, opening up new possibilities for creating personalized and enriching experiences for users.

## Installation

This project uses Git submodules to include external dependencies.

### Option 1: Clone with Submodules (Recommended)

To clone this repository along with all its submodules in one step:

```sh
git clone --recursive https://github.com/SherryLabs/sherry-contracts.git
```

### Option 2: Repository already cloned without the `--recursive`

If you've already cloned the repository without using the `--recursive` flag, you can fetch the submodules with:

```sh
git submodule update --init
```

### Option 3: Update all submodules to their latest commits

If you want to update all submodules to their latest commits on their respective branches:

```sh
git submodule update --init --recursive --remote
```

## Contract Addresses

## Cross-Chain Interoperability

Our contracts enable seamless cross-chain interactions through multiple interoperability solutions.

<!-- Consider adding a diagram showing cross-chain interactions -->
<!-- ![Cross-Chain Architecture](./assets/cross-chain-diagram.png) -->

### Wormhole Integration

These contracts leverage Wormhole to connect Avalanche with all other chains supported by the Wormhole protocol, enabling bidirectional communication between Avalanche and various blockchain networks.

#### SL1MessageSender.sol

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `SL1MessageSender`     | `0xCa342963D6E9CAD9DB192F57691942B3860A7492`   | `Avalanche C-Chain`    |
| `SL1MessageSender`     | `0x3C5d800b8e9F8487708a542654143e9564a65f2c`   | `Avalanche Fuji`    |
| `SL1MessageSender`     | `0x812810512193d623a68e467cc314511a581E4546`   | `Celo`    |
| `SL1MessageSender`     | `0xd6b8f5Ddf0dA19C4bEF691A93666605A451A39Cc`   | `Celo Alfajores`    |
| `SL1MessageSender`     | `0x36285B0876E0B45771C5c76885B35d4FE5b39b10`   | `Base`    |
| `SL1MessageSender`     | `0x22b79dB03361689644EBc9d00bd131cB44e9f93d`   | `Base Sepolia`    |
| `SL1MessageSender`     | `0x22bf4Be375941853e42ce559258362819b7ee637`   | `Ethereum`    |
| `SL1MessageSender`     | `0x5F5Bb1bAdDB3B428874393e6E4F2623Fa67AF49c`   | `Ethereum Sepolia`    |

#### SL1MessageReceiver.sol

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `SL1MessageReceiver`     | `0xa1Aa6d54D5379576d7968EbFef67F1A382396c39`   | `Avalanche C-Chain`    |
| `SL1MessageReceiver`     | `0x74bD0f6214490a83D56606684405FB0e3e48b038`   | `Avalanche Fuji`    |
| `SL1MessageReceiver`     | `0x21fb3E1D7a7a218fdd9C28b0b18D8b9Cb49Fe259`   | `Celo`    |
| `SL1MessageReceiver`     | `0x4DC7CdD6d7062add8bB3e4512E987aC111388335`   | `Celo Alfajores`    |
| `SL1MessageReceiver`     | `0x21fb3E1D7a7a218fdd9C28b0b18D8b9Cb49Fe259`   | `Base`    |
| `SL1MessageReceiver`     | `0x6451fB63747eE21Cf866203092228c770fbd8D35`   | `Base Sepolia`    |
| `SL1MessageReceiver`     | `0xE46b6b941BbBf93be4D422C96aaf4749CAf9a386`   | `Ethereum`    |
| `SL1MessageReceiver`     | `0xc96FC8c19D0b9f6D1B68114a4565aD40117e55B1`   | `Ethereum Sepolia`    |

### Avalanche Ecosystem Interoperability

Our solution also provides native interoperability within the Avalanche ecosystem, connecting the C-Chain with various L1 subnets in the Avalanche network. This is achieved through our specialized contracts:

<!-- Consider adding a diagram showing Avalanche ecosystem connectivity -->
<!-- ![Avalanche Ecosystem](./assets/avalanche-ecosystem.png) -->

#### SL1Sender.sol

This contract enables sending messages from Avalanche C-Chain to any L1 subnet within the Avalanche ecosystem.

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `SL1Sender`     | `0x42E610784cf9fB37Ea0D33919100Cf7b54D87500`   | `Avalanche C-Chain`    |

#### SL1AnyChainReceiver.sol

This contract handles the reception of messages from any L1 subnet within the Avalanche ecosystem.

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|

### KOL Router Factories

These factories are used to deploy new KOL (Key Opinion Leader) specific routers for different DEX protocols.

#### TraderJoe KOL Factory

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `KOLFactoryTraderJoe`     | `0x4aFA9180928fc6A90050B8AF850eCDA94238418e`   | `Avalanche C-Chain`    |
| `KOLFactoryTraderJoe`     | `0x375A9602c78D32a733Ddc84DeEdfd9305822B9F6`   | `Avalanche Fuji`    |

#### Uniswap KOL Factory

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `KOLFactoryUniswap`     | `0xB85cEcD024DCDd6eF3BBADabacd0CDEC4a71B3e4`   | `Ethereum Sepolia`    |

#### Other Contracts

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `CaptureFlagWH`     | `0x812810512193d623a68e467cc314511a581E4546`   | `Celo Alfajores`    |

# Docs

In order to learn more about Sherry go to our [docs](https://docs.sherry.social)

---

<div align="center">

  [![Twitter](https://img.shields.io/twitter/follow/SherryProtocol?style=social)](https://twitter.com/SherryProtocol)
  [![Discord](https://img.shields.io/discord/4HppNS46)](https://discord.gg/4HppNS46)
  [![GitHub](https://img.shields.io/github/stars/sherry-protocol/sherry-contracts?style=social)](https://github.com/sherry-protocol/sherry-contracts)

</div>


