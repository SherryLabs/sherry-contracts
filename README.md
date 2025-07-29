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

### Mainnet Deployments

#### SL1MessageSender.sol

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `SL1MessageSender`     | `0xe41C42Ccc6370Aef75Bca3287396659F39CC4f2D`   | `Avalanche C-Chain (43114)`    |
| `SL1MessageSender`     | `0x16546E8FE5Ea8277005c98B32C201f43B9b43C16`   | `Celo (42220)`    |
| `SL1MessageSender`     | `0xb0c46cAb920d4577ad6F901D7C56972836A981ad`   | `Base (8453)`    |

#### SL1MessageReceiver.sol

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `SL1MessageReceiver`     | `0x6B520163Db9eC91a34dDE572f4174e1de09A7E9D`   | `Avalanche C-Chain (43114)`    |
| `SL1MessageReceiver`     | `0xe0e07c70b7fB31d58AFf69C1750520baebaa632D`   | `Celo (42220)`    |
| `SL1MessageReceiver`     | `0xbd84C59CE99A4A6e48727DA7581794442BA7C2eD`   | `Base (8453)`    |

### Testnet Deployments

#### SL1MessageSender.sol

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `SL1MessageSender`     | `0xd7a2e6Ee0A148A50EF7cac6730eEDaeecE59E388`   | `Avalanche Fuji (43113)`    |
| `SL1MessageSender`     | `0x16546E8FE5Ea8277005c98B32C201f43B9b43C16`   | `Celo Alfajores (44787)`    |
| `SL1MessageSender`     | `0xb0c46cAb920d4577ad6F901D7C56972836A981ad`   | `Base Sepolia (84532)`    |
| `SL1MessageSender`     | `0x5AeFC2a2B4beB709a7E77b19Ba3596e0675f8140`   | `Ethereum Sepolia (11155111)`    |

#### SL1MessageReceiver.sol

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `SL1MessageReceiver`     | `0x40F9eDf329f43dB834Fb677B076FF1Ad7d165b57`   | `Avalanche Fuji (43113)`    |
| `SL1MessageReceiver`     | `0x6cEc2B70F7D32f5DD5a2065DDEB8Ed16C7cf9a54`   | `Celo Alfajores (44787)`    |
| `SL1MessageReceiver`     | `0xbd84C59CE99A4A6e48727DA7581794442BA7C2eD`   | `Base Sepolia (84532)`    |
| `SL1MessageReceiver`     | `0xA1A0AAe4f65Dce959D0B66738f78887a844CEc40`   | `Ethereum Sepolia (11155111)`    |

## Cross-Chain Interoperability

Our contracts enable seamless cross-chain interactions through multiple interoperability solutions.

<!-- TODO: Consider adding a diagram showing cross-chain interactions -->
<!-- ![Cross-Chain Architecture](./assets/cross-chain-diagram.png) -->

### Wormhole Integration

These contracts leverage Wormhole to connect Avalanche with all other chains supported by the Wormhole protocol, enabling bidirectional communication between Avalanche and various blockchain networks.

### Avalanche Ecosystem Interoperability

Our solution also provides native interoperability within the Avalanche ecosystem, connecting the C-Chain with various L1 subnets in the Avalanche network. This is achieved through our specialized contracts:

<!-- TODO: Consider adding a diagram showing Avalanche ecosystem connectivity -->
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

#### TraderJoe/LFJ KOL Factory

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `KOLFactoryTraderJoe`     | `0x5F5Bb1bAdDB3B428874393e6E4F2623Fa67AF49c`   | `Avalanche C-Chain`    |
| `KOLFactoryTraderJoe`     | `0x331c5162aEe34Fa6Fb1d4Ac538264eBC376aB5c4`   | `Avalanche Fuji`    |

#### Pangolin KOL Factory

| Contract Name | Address | Chain |
|---------------|----------------------------------------------|--------|
| `KOLFactoryTraderJoe`     | `0xc96FC8c19D0b9f6D1B68114a4565aD40117e55B1`   | `Avalanche C-Chain`    |
| `KOLFactoryTraderJoe`     | `0x0cbe9C578cc875Eee855483233d1222552068aA2`   | `Avalanche Fuji`    |

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


