

# Contents
- [interfaces](/contracts/kol-router/interfaces)
- [KOLFactoryBase](KOLFactoryBase.sol/abstract.KOLFactoryBase.md)
- [KOLFactoryTraderJoe](KOLFactoryTraderJoe.sol/contract.KOLFactoryTraderJoe.md)
- [KOLFactoryUniswap](KOLFactoryUniswap.sol/contract.KOLFactoryUniswap.md)
- [KOLRouterTraderJoe](KOLRouterTraderJoe.sol/contract.KOLRouterTraderJoe.md)
- [KOLRouterUniswap](KOLRouterUniswap.sol/contract.KOLRouterUniswap.md)
- [KOLSwapRouterBase](KOLSwapRouterBase.sol/abstract.KOLSwapRouterBase.md)

# KOL Router System

## Overview
The KOL Router System is a set of smart contracts designed to enable Key Opinion Leaders (KOLs) to promote token sales through Sherry Links (Mini-Apps). The system routes user swap transactions to various DEX protocols (Uniswap, TraderJoe, Pharaoh, etc.) while collecting a small fee in the native token for the KOL.

## Architecture

The system follows a modular architecture with base contracts providing common functionality and protocol-specific implementations:

```
                          ┌────────────────────────────────┐
                          │       KOLSwapRouterBase        │
                          │  (Common router functionality) │
                          └───────────────┬────────────────┘
                                          │
                                          │ extends
                                          │
          ┌───────────────────────────────┼───────────────────────────────┐
          │                               │                               │
          ▼                               ▼                               ▼
┌───────────────────────────┐ ┌────────────────────────────┐ ┌───────────────────────────┐
│    KOLRouterUniswap       │ │    KOLRouterTraderJoe      │ │    KOLRouterPharaoh       │
│(Uniswap-specific methods) │ │(TraderJoe-specific methods)│ │(Pharaoh-specific methods) │
└───────────────────────────┘ └────────────────────────────┘ └───────────────────────────┘
          ▲                               ▲                               ▲
          │                               │                               │
          │ creates                       │ creates                       │ creates
          │                               │                               │
┌───────────────────────────┐ ┌───────────────────────────┐ ┌───────────────────────────┐
│    KOLFactoryUniswap      │ │    KOLFactoryTraderJoe    │ │    KOLFactoryPharaoh      │
└───────────────┬───────────┘ └───────────────┬───────────┘ └───────────────┬───────────┘
                │                             │                             │
                │ extends                     │ extends                     │ extends
                │                             │                             │
                ▼                             ▼                             ▼
          ┌───────────────────────────────────────────────────────────────────┐
          │                         KOLFactoryBase                            │
          │               (Common factory functionality)                      │
          └───────────────────────────────────────────────────────────────────┘
```

### Core Components

#### Base Contracts
- **KOLSwapRouterBase**: Abstract contract containing common functionality for all KOL routers:
  - Fee management
  - Security controls
  - Withdrawal functionality
  - Event definitions

- **KOLFactoryBase**: Abstract contract containing common functionality for all factory contracts:
  - KOL router registration
  - Router tracking
  - Access control
  - Common factory methods

#### Protocol-Specific Implementations

1. **Router Contracts**
   - **KOLRouterUniswap**: Implements Uniswap-specific swap functions
   - **KOLRouterTraderJoe**: Implements TraderJoe-specific swap functions
   - **KOLRouterPharaoh**: Implements Pharaoh-specific swap functions

2. **Factory Contracts**
   - **KOLFactoryUniswap**: Creates and manages Uniswap KOL routers
   - **KOLFactoryTraderJoe**: Creates and manages TraderJoe KOL routers
   - **KOLFactoryPharaoh**: Creates and manages Pharaoh KOL routers

## Workflow

1. A KOL registers to be part of the system
2. A protocol-specific factory contract creates a dedicated router for the KOL
3. The KOL can customize their fee (within limits)
4. Users can swap tokens through the KOL's router:
   - A small fee is taken in the native token (e.g., AVAX)
   - The rest of the transaction is routed to the appropriate DEX
5. The KOL can withdraw their accumulated fees

## Key Features

- **Protocol-Specific Routing**: Each router is optimized for a specific DEX protocol
- **Fee Customization**: KOLs can set their own fees (within predefined limits)
- **Security**: Built-in protection against reentrancy and other common attacks
- **Modularity**: Easy to add support for new DEX protocols
- **Transparency**: Events emitted for all key actions

## Supported DEX Protocols

- Uniswap V4, V3 & V2
- TraderJoe V1 & V2
- Pharaoh