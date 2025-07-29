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
| `SL1MessageSender`     | `0x022dCe2109655C5a849E1631a412d34c33Eb7A79`   | `Avalanche C-Chain`    |
| `SL1MessageSender`     | ``   | `Avalanche Fuji`    |
| `SL1MessageSender`     | ``   | `Celo`    |
| `SL1MessageSender`     | ``   | `Celo Alfajores`    |
| `SL1MessageSender`     | `0x9c9f3052Fcdde50d6E1f9241d6b3b35044FACec0`   | `Base`    |
| `SL1MessageSender`     | ``   | `Base Sepolia`    |
| `SL1MessageSender`     | ``   | `Ethereum`    |
| `SL1MessageSender`     | ``   | `Ethereum Sepolia`    |

#### SL1MessageReceiver.sol

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `SL1MessageReceiver`     | `0x93D1b20F0Cd17958Fcc17A59B07AcD4d304618f8`   | `Avalanche C-Chain`    |
| `SL1MessageReceiver`     | ``   | `Avalanche Fuji`    |
| `SL1MessageReceiver`     | `0xe0e07c70b7fB31d58AFf69C1750520baebaa632D`   | `Celo`    |
| `SL1MessageReceiver`     | ``   | `Celo Alfajores`    |
| `SL1MessageReceiver`     | ``   | `Base`    |
| `SL1MessageReceiver`     | ``   | `Base Sepolia`    |
| `SL1MessageReceiver`     | ``   | `Ethereum`    |
| `SL1MessageReceiver`     | ``   | `Ethereum Sepolia`    |

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


