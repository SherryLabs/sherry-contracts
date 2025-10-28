# Somnia KOL Router Implementation

## Overview

This directory contains the Somnia-optimized KOL Router implementation. Due to Somnia's unique gas economics, this implementation uses a **minimal 2-function approach** with the **EIP-1167 Minimal Proxy (Clone) pattern** to stay within Somnia's deployment gas limits.

## Somnia Gas Economics

Somnia has significantly different gas costs compared to Ethereum:

- **Contract Deployment**: **3,125 gas per byte** of bytecode (vs 200 on Ethereum - **15.6x more expensive**)
- **Max Gas Limit**: **30,000,000 gas per transaction**
- **Storage Operations**: Dynamic pricing based on recency (hot vs cold storage)
- **Precompiles**: 10x-250x more expensive than Ethereum

This means a contract that costs ~1M gas to deploy on Ethereum could cost **15M+ gas on Somnia**, making bytecode optimization critical.

## Implementation Details

### Architecture

We use the **Clone Pattern (EIP-1167)** to minimize deployment costs:

1. **Implementation Contract** (`KOLRouterSomniaV2TwoFunc.sol`): Deployed once as a master template
2. **Factory Contract** (`KOLFactorySomniaCloneable.sol`): Creates cheap clones of the implementation
3. **Clone Instances**: Each KOL gets a minimal proxy (~100 bytes) that delegates to the implementation

### Gas Analysis

**Original Full Router:**
- Bytecode: 12,009 bytes
- Estimated deployment: ~76M gas ❌ (exceeds 30M limit)

**Optimized 2-Function Router:**
- Bytecode: 5,961 bytes
- Estimated deployment: ~28M gas ✅ (within 30M limit)
- Margin: +2M gas safety buffer

## Included Functions

### Core Swap Functions (Logic Intact)

#### 1. `swapExactTokensForTokens`
```solidity
function swapExactTokensForTokens(
    uint amtIn,
    uint amtOutMin,
    address[] calldata path,
    address to,
    uint deadline
) external nonReentrant returns (uint[] memory amounts)
```

**Purpose**: Swap exact amount of ERC20 tokens for another ERC20 token

**Flow**:
1. Transfers input tokens from user
2. Deducts fees (KOL, Foundation, Treasury)
3. Approves DEX router for swap amount
4. Executes swap via Somnia DEX
5. Emits SwapExecuted event

**Fees**: Distributed according to factory configuration (default: 1% KOL, 0.5% Foundation, 0.5% Treasury)

---

#### 2. `swapExactAVAXForTokens`
```solidity
function swapExactAVAXForTokens(
    uint amtOutMin,
    address[] calldata path,
    address to,
    uint deadline
) external payable nonReentrant returns (uint[] memory amounts)
```

**Purpose**: Swap exact amount of native AVAX for ERC20 tokens

**Flow**:
1. Receives native AVAX via `msg.value`
2. Deducts fees and sends to Foundation/Treasury
3. Executes swap with remaining AVAX
4. Emits SwapExecuted event

**Note**: Fees are paid in native AVAX

---

### Administrative Functions

#### 3. `withdrawKOLFees`
```solidity
function withdrawKOLFees(address[] calldata toks) external nonReentrant
```

**Purpose**: Allows KOL to withdraw accumulated fees

**Access**: KOL address only

**Behavior**:
- Withdraws all native balance to KOL
- Withdraws specified ERC20 token balances to KOL
- Protected by reentrancy guard

---

#### 4. `initialize`
```solidity
function initialize(
    address _kol,
    address _dex,
    address _factory,
    address _foundation,
    address _treasury
) external
```

**Purpose**: Initialize a cloned router instance

**Access**: Can only be called once per clone

**Parameters**:
- `_kol`: KOL's wallet address
- `_dex`: Somnia DEX router address
- `_factory`: Factory contract address
- `_foundation`: Sherry Foundation address
- `_treasury`: Sherry Treasury address

---

## Missing Functions (Removed for Size Optimization)

The following functions from the full router are **NOT included** in this Somnia implementation:

### Token → Native Swaps
- ❌ `swapExactTokensForAVAX` - Swap exact ERC20 for native AVAX
- ❌ `swapTokensForExactAVAX` - Swap ERC20 for exact native AVAX

### Exact Output Swaps
- ❌ `swapTokensForExactTokens` - Swap ERC20 for exact amount of another ERC20
- ❌ `swapAVAXForExactTokens` - Swap native AVAX for exact amount of ERC20

### Utility Functions
- ❌ `calculateNetAmount` - Calculate net amount after fees
- ❌ `getKOLFeeBalance` - Get fee balance for single token
- ❌ `getKOLFeeBalances` - Get fee balances for multiple tokens

### Rationale

These functions were removed to achieve the required bytecode size reduction. The two included swap functions (`swapExactTokensForTokens` and `swapExactAVAXForTokens`) cover the most common use cases:

1. **ERC20 → ERC20 swaps**: Standard token trading
2. **Native → ERC20 swaps**: Entry point for users with native AVAX

If reverse swaps (Token → Native) or exact output swaps are needed, they can be:
- Implemented in a separate companion contract
- Added when Somnia increases gas limits
- Handled at the frontend/aggregator level

## Deployment

### Contracts Deployed

1. **Implementation**: `KOLRouterSomniaV2TwoFunc`
   - Address: `0x2A62F92089192AdA795DB6D7BBCB2b0ed49e1cF1` (Somnia Testnet)
   - Deployed once as master template

2. **Factory**: `KOLFactorySomniaCloneable`
   - Creates minimal proxy clones
   - Manages KOL router instances

### Deployment Script

```bash
npx hardhat ignition deploy ignition/modules/KOLFactorySomnia.ts --network somniaTestnet
```

### Verification

```bash
# Verify implementation
npx hardhat verify --network somniaTestnet <IMPLEMENTATION_ADDRESS>

# Verify factory
npx hardhat verify --network somniaTestnet <FACTORY_ADDRESS> \
  <DEX_ROUTER> <FOUNDATION_ADDRESS> <TREASURY_ADDRESS> <IMPLEMENTATION_ADDRESS>
```

## Usage Example

### Creating a KOL Router

```javascript
const factory = await ethers.getContractAt("KOLFactorySomniaCloneable", factoryAddress);
const tx = await factory.createKOLRouter(kolAddress);
const receipt = await tx.wait();

// Get router address from event
const event = receipt.events.find(e => e.event === "RouterCreated");
const routerAddress = event.args.routerAddress;
```

### Executing a Swap

```javascript
const router = await ethers.getContractAt("KOLRouterSomniaV2TwoFunc", routerAddress);

// ERC20 → ERC20 swap
const token = await ethers.getContractAt("IERC20", tokenAddress);
await token.approve(routerAddress, amountIn);

const tx = await router.swapExactTokensForTokens(
  amountIn,
  amountOutMin,
  [tokenIn, tokenOut],
  recipientAddress,
  deadline
);

// Native → ERC20 swap
const tx = await router.swapExactAVAXForTokens(
  amountOutMin,
  [WAVAX, tokenOut],
  recipientAddress,
  deadline,
  { value: amountIn }
);
```

### Withdrawing KOL Fees

```javascript
// Withdraw native AVAX fees
await router.withdrawKOLFees([]);

// Withdraw ERC20 fees
await router.withdrawKOLFees([token1Address, token2Address]);
```

## Security Considerations

1. **Reentrancy Protection**: All swap and withdrawal functions use the `nonReentrant` modifier
2. **Initialization**: Clones can only be initialized once to prevent re-initialization attacks
3. **Access Control**: Only KOL can withdraw accumulated fees
4. **Fee Distribution**: Foundation and Treasury fees are immediately distributed, reducing attack surface

## Gas Optimization Techniques Used

1. **Removed OpenZeppelin Upgradeable Libraries**: Manual reentrancy guard implementation
2. **Shortened Variable Names**: `amt` instead of `amount`, `kf` instead of `kolFee`
3. **Minimal Event Emission**: Single comprehensive event instead of multiple events
4. **Direct Transfers**: Using `transfer()` instead of `safeTransfer()` where safe
5. **Removed Helper Functions**: Inlined calculations where possible
6. **Clone Pattern**: ~100 byte proxies instead of full contract deployments per KOL

## Future Improvements

### When Somnia Increases Gas Limits

If Somnia increases the deployment gas limit, we can:
1. Add reverse swap functions (Token → Native)
2. Add exact output swap functions
3. Include helper/utility functions
4. Add comprehensive fee balance queries

### Potential Upgrades

- Multi-hop swap optimization
- Flash loan integration
- Batch swap support
- Advanced slippage protection

## Technical Specifications

- **Solidity Version**: 0.8.29
- **License**: MIT
- **Optimizer**: Enabled (999,999 runs for minimal deployment size)
- **Pattern**: EIP-1167 Minimal Proxy
- **Network**: Somnia Testnet (Chain ID: 50312)

## Contract Addresses

### Somnia Testnet
- Implementation: `0x2A62F92089192AdA795DB6D7BBCB2b0ed49e1cF1`
- Factory: TBD (pending sufficient deployer balance)

### Mainnet
- Not yet deployed

## Support

For issues or questions regarding the Somnia implementation:
1. Check Somnia documentation: https://docs.somnia.network/
2. Review gas economics: See "Somnia Gas Differences" section
3. Compare with full router implementation in parent directory
