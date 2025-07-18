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
| `SL1MessageSender`     | `0xe0e07c70b7fB31d58AFf69C1750520baebaa632D`   | `Avalanche C-Chain`    |
| `SL1MessageSender`     | `0x1b412E757bc8359b401BcF7B0b82215c33a9B71f`   | `Avalanche Fuji`    |
| `SL1MessageSender`     | `0x`   | `Celo`    |
| `SL1MessageSender`     | `0x`   | `Celo Alfajores`    |
| `SL1MessageSender`     | `0x`   | `Base`    |
| `SL1MessageSender`     | `0x`   | `Mantle`    |

#### SL1MessageReceiver.sol

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `SL1MessageReceiver`     | `0x`   | `Avalanche C-Chain`    |
| `SL1MessageReceiver`     | `0xCfAfb96446C6Bd2a477D327215D358626d944E13`   | `Avalanche Fuji`    |
| `SL1MessageReceiver`     | `0x21fb3E1D7a7a218fdd9C28b0b18D8b9Cb49Fe259`   | `Celo`    |
| `SL1MessageReceiver`     | `0x4DC7CdD6d7062add8bB3e4512E987aC111388335`   | `Celo Alfajores`    |
| `SL1MessageReceiver`     | `0x`   | `Base`    |
| `SL1MessageReceiver`     | `0x`   | `Mantle`    |

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
| `KOLFactoryTraderJoe`     | `0xd7f21898f4D4fb89d70ac4f22F540Ece263b2f38`   | `Avalanche C-Chain`    |
| `KOLFactoryTraderJoe`     | `0x6Ee892Bc5102ef22BF7064032FcDBE1Dc5e1dD5c`      | `Avalanche Fuji`    |

#### Uniswap KOL Factory

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `KOLFactoryUniswap`     | `0x`   | `Ethereum Mainnet`    |
| `KOLFactoryUniswap`     | `0xB85cEcD024DCDd6eF3BBADabacd0CDEC4a71B3e4`   | `Ethereum Sepolia`    |

#### Pangolin KOL Factory

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `KOLFactoryPangolin`     | `0x929FAdE8AA2104df52F337cbACcFf94F0ec120E5`   | `Avalanche C-Chain`    |
| `KOLFactoryPangolin`     | `0x49c9455A7AF8454EAc6A4fDA0271A372136bf6Ae`   | `Avalanche Fuji`    |

#### ArenaSwap KOL Factory

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `KOLFactoryArenaSwap`     | `0x13F8A20fcdd364aE59355A1135CFe80A1CD7580d`   | `Avalanche C-Chain`    |

# Docs

In order to learn more about Sherry go to our [docs](https://docs.sherry.social)

---

<div align="center">

  [![Twitter](https://img.shields.io/twitter/follow/SherryProtocol?style=social)](https://twitter.com/SherryProtocol)
  [![Discord](https://img.shields.io/discord/4HppNS46)](https://discord.gg/4HppNS46)
  [![GitHub](https://img.shields.io/github/stars/sherry-protocol/sherry-contracts?style=social)](https://github.com/sherry-protocol/sherry-contracts)
  
</div>


