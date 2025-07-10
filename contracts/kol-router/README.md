# KOLSwapRouter System

## 1. Introduction

The **KOLSwapRouter** system enables Key Opinion Leaders (KOLs) to promote and monetize token transactions through dedicated smart contract routers. These routers are designed to be integrated into **Sherry's mini-apps**, which render interactive swap interfaces directly within social media platforms such as Discord, YouTube, and X (formerly Twitter). 

The system implements a **percentage-based fee structure** where KOLs earn a configurable percentage (default 1%) of the input token amount from each user-initiated swap, while the Sherry Foundation and Treasury also receive their respective portions (0.5% each) to support ecosystem development. All fees are calculated as percentages of the input token, supporting both native tokens (e.g., AVAX) and ERC20 tokens across supported DEX protocols like ArenaSwap, TraderJoe, and Pangolin.

## 2. System Architecture

### Overview Diagram

```
                          +--------------------------------+
                          |       KOLSwapRouterBase        |
                          |  (Common router functionality) |
                          |    - Percentage fee system     |
                          |    - Foundation/Treasury fees  |
                          +---------------+----------------+
                                          |
                                          | extends
                                          |
          +-------------------------------+-------------------------------+
          |                               |                               |
          v                               v                               v
+---------------------------+ +----------------------------+ +----------------------------+
|    KOLRouterArenaSwap       | |    KOLRouterTraderJoe      | |    KOLRouterPangolin       |
|(ArenaSwap-specific methods) | |(TraderJoe-specific methods)| |(Pangolin-specific methods) |
+---------------------------+ +----------------------------+ +----------------------------+
          ^                               ^                               ^
          |                               |                               |
          | creates                       | creates                       | creates
          |                               |                               |
+---------------------------+ +---------------------------+ +---------------------------+
|    KOLFactoryArenaSwap      | |    KOLFactoryTraderJoe    | |    KOLFactoryPangolin     |
+---------------+-----------+ +---------------+-----------+ +---------------+-----------+
                |                             |                             |
                | extends                     | extends                     | extends
                |                             |                             |
                v                             v                             v
          +-------------------------------------------------------------------+
          |                         KOLFactoryBase                            |
          |               (Common factory functionality)                      |
          |               - Configurable fee rates (BPS)                     |
          |               - Foundation/Treasury management                    |
          +-------------------------------------------------------------------+
```

### Key Layers

- **Router Base**: Common router logic including percentage-based fee processing, multi-token withdrawals, access control.
- **Protocol Routers**: Protocol-specific integrations with ArenaSwap, TraderJoe, Pangolin.
- **Factory Base**: Common factory logic to deploy and manage routers, configure fee rates, and manage Foundation/Treasury addresses.
- **Protocol Factories**: Create routers for individual KOLs for each protocol with updated constructor parameters.

### Fee Structure

The system implements a **2% total fee** on input tokens, distributed as follows:

- **KOL Fee (1%)**: Accumulated in the router contract for later withdrawal by the KOL
- **Foundation Fee (0.5%)**: Sent immediately to Sherry Foundation address during each swap
- **Treasury Fee (0.5%)**: Sent immediately to Sherry Treasury address during each swap

All fee rates are configurable through the factory contract and measured in basis points (BPS).

## 3. Workflow

1. A KOL registers through a protocol-specific factory.
2. The factory deploys a dedicated router contract for that KOL with the current fee configuration.
3. Fee rates are managed at the factory level and can be updated by the factory owner.
4. Users interact with the KOL router to perform swaps:
   - The router calculates percentage-based fees from the input token amount.
   - Foundation and Treasury fees are sent immediately to their respective addresses.
   - KOL fees are accumulated in the router contract.
   - The remaining amount (net amount) is routed via the target DEX.
5. The KOL can withdraw accumulated fees for multiple tokens at any time using batch withdrawal.

## 4. Swap Flow Description

This section describes the detailed flow of each supported swap operation initiated by a user through a KOLRouter with the new percentage-based fee system.

> Note: The function names shown here are representative. Actual function names may vary slightly depending on the protocol integration, but the available swap types remain consistent across all supported protocols.

### Involved Parties

- **User Wallet**: The wallet initiating the swap.
- **KOL Router Contract**: The proxy handling the swap and fee distribution.
- **DEX Router Contract**: The official router from the respective protocol (e.g., ArenaSwap, LBRouter).
- **KOL Wallet**: The recipient of accumulated KOL fees.
- **Sherry Foundation**: Receives 0.5% of input tokens immediately.
- **Sherry Treasury**: Receives 0.5% of input tokens immediately.

### 4.1 swapExactNATIVEForToken

![Swap Native to Token](../../images/kolrouterNativeToToken.png)

1. The **user wallet** sends native tokens (e.g., AVAX) and calls `swapExactNATIVEForToken` on the **KOLRouter**.
2. The **KOLRouter**:
   - Calculates percentage-based fees from the input amount:
     - KOL Fee (1%): Accumulated in contract
     - Foundation Fee (0.5%): Sent immediately to Foundation address
     - Treasury Fee (0.5%): Sent immediately to Treasury address
   - Forwards the remaining amount (98%) to the **DEX Router**.
3. The **DEX Router** swaps the received AVAX for the desired ERC20 token and sends it to the **user wallet**.
4. Emits `SwapExecuted` event with detailed fee breakdown.

### 4.2 swapExactTokenForNATIVE

![Swap Token to Native](../../images/kolrouterTokenToNative.png)

1. The **user wallet** approves the **KOLRouter** to spend ERC20 tokens, then calls `swapExactTokenForNATIVE`.
2. The **KOLRouter**:
   - Transfers the full ERC20 token amount from the **user wallet**.
   - Calculates percentage-based fees from the input tokens:
     - KOL Fee (1%): Kept in contract
     - Foundation Fee (0.5%): Sent immediately to Foundation address  
     - Treasury Fee (0.5%): Sent immediately to Treasury address
   - Approves the **DEX Router** to spend the net amount (98%) and forwards them.
3. The **DEX Router** swaps tokens for native currency and sends it to the **user wallet**.

### 4.3 swapExactTokenForToken

![Swap Token to Token](../../images/kolrouterTokenToToken.png)

1. The **user wallet** approves the **KOLRouter** to spend ERC20 tokens, then calls `swapExactTokenForToken`.
2. The **KOLRouter**:
   - Transfers the full ERC20 token amount from the **user wallet**.
   - Calculates percentage-based fees from the input tokens:
     - KOL Fee (1%): Accumulated in contract
     - Foundation Fee (0.5%): Sent immediately to Foundation address
     - Treasury Fee (0.5%): Sent immediately to Treasury address
   - Approves and forwards the net amount (98%) to the **DEX Router**.
3. The **DEX Router** swaps the input token for another token and sends it to the **user wallet**.

### 4.4 withdrawKOLFees Flow (Multi-Token Support)

This flow can be initiated by the KOL at any time to retrieve their accumulated fees across multiple tokens.

![Withdraw Fees](../../images/kolrouterWithdrawFee.png)

1. The **KOL Wallet** calls `withdrawKOLFees(tokenAddresses[])` on the **KOLRouter**.
2. The **KOLRouter**:
   - Always checks and withdraws native token balance if available.
   - Iterates through the provided token addresses array.
   - Transfers accumulated fees for each token to the **KOL Wallet**.
   - Supports both native tokens and ERC20 tokens in a single transaction.

### 4.5 Fee Calculation and Preview

Users and frontends can preview fees before executing swaps:

1. Call `calculateNetAmount(inputAmount)` to get the amount after fees.
2. Fee breakdown calculation:
   ```
   Input Amount: 1000 tokens
   ├── KOL Fee (1%): 10 tokens → Router contract
   ├── Foundation Fee (0.5%): 5 tokens → Foundation address  
   ├── Treasury Fee (0.5%): 5 tokens → Treasury address
   └── Net Amount (98%): 980 tokens → DEX swap
   ```

## 5. Fee Management

### Factory-Level Configuration

Fee rates are managed at the factory level and apply to all routers created by that factory:

- **Owner Control**: Only factory owner can update fee rates
- **Validation**: Total fees cannot exceed 100% (10000 basis points)
- **Flexibility**: Each fee component can be adjusted independently
- **Events**: Fee rate changes emit `FeeRatesUpdated` events

### Example Fee Configuration:

```solidity
// Update fee rates (only factory owner)
factory.setFeeRates(
    150,  // KOL fee: 1.5%
    75,   // Foundation fee: 0.75%  
    75    // Treasury fee: 0.75%
);
// Total: 3% fees
```

### Multi-Token Fee Queries

KOLs can query their accumulated fees across multiple tokens:

```solidity
// Query single token balance
uint256 balance = router.getKOLFeeBalance(tokenAddress);

// Query multiple token balances
address[] memory tokens = [nativeToken, usdcToken, wavaxToken];
uint256[] memory balances = router.getKOLFeeBalances(tokens);
```

## 6. Security Considerations

- **Access Control**: `Ownable` and `onlyKOL` patterns restrict sensitive operations.
- **Reentrancy Protection**: All routers use `ReentrancyGuard` to prevent recursive attacks.
- **Immediate Distribution**: Foundation and Treasury fees are sent immediately, reducing contract risk.
- **Safe Transfers**: All token transfers use `SafeERC20` for enhanced security.
- **Event Logging**: All key actions emit detailed events (`SwapExecuted`, `FeeRatesUpdated`).
- **Input Validation**: Fee calculations validate against overflow and underflow.

## 7. Extensibility

Adding new protocols involves:

1. Creating a new `KOLRouterX` contract inheriting `KOLSwapRouterBase`
2. Implementing swap calls using the respective DEX SDK/API with percentage fee integration
3. Creating a `KOLFactoryX` contract inheriting `KOLFactoryBase`
4. Updating constructor to include Foundation and Treasury addresses

This modular architecture allows safe, incremental expansion while maintaining the consistent fee structure across all protocols.

## 8. Supported DEX Protocols

- ArenaSwap V1
- TraderJoe V1, V2.x
- Pangolin V2

## 10. Technical References

For detailed function signatures, inheritance structure, and technical specifications, refer to the following contract documentation:

 - [❱ interfaces](contracts/kol-router/interfaces/README.md)
   - [IArenaRouter01](contracts/kol-router/interfaces/IArenaRouter01.sol/interface.IArenaRouter01.md)
   - [IKOLFactory](contracts/kol-router/interfaces/IKOLFactory.sol/interface.IKOLFactory.md)
   - [ILBRouter](contracts/kol-router/interfaces/ILBRouter.sol/interface.ILBRouter.md)
   - [IPangolinRouter](contracts/kol-router/interfaces/IPangolinRouter.sol/interface.IPangolinRouter.md)
   - [IUniversalRouter](contracts/kol-router/interfaces/IUniversalRouter.sol/interface.IUniversalRouter.md)
 - [KOLFactoryArenaSwap](contracts/kol-router/KOLFactoryArenaSwap.sol/contract.KOLFactoryArenaSwap.md)
 - [KOLFactoryBase](contracts/kol-router/KOLFactoryBase.sol/abstract.KOLFactoryBase.md)
 - [KOLFactoryPangolin](contracts/kol-router/KOLFactoryPangolin.sol/contract.KOLFactoryPangolin.md)
 - [KOLFactoryTraderJoe](contracts/kol-router/KOLFactoryTraderJoe.sol/contract.KOLFactoryTraderJoe.md)
 - [KOLRouterArenaSwap](contracts/kol-router/KOLRouterArenaSwap.sol/contract.KOLRouterArenaSwap.md)
 - [KOLRouterPangolinV2](contracts/kol-router/KOLRouterPangolinV2.sol/contract.KOLRouterPangolinV2.md)
 - [KOLRouterTraderJoe](contracts/kol-router/KOLRouterTraderJoe.sol/contract.KOLRouterTraderJoe.md)
 - [KOLSwapRouterBase](contracts/kol-router/KOLSwapRouterBase.sol/abstract.KOLSwapRouterBase.md)