# KOLFactoryBase
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/ac3659d9daf69f5807477dfb4ad35c396dc00c1f/contracts/kol-router/KOLFactoryBase.sol)

**Inherits:**
Ownable

*Abstract base contract for protocol-specific KOL router factories*


## State Variables
### kolToRouters

```solidity
mapping(address => address[]) kolToRouters;
```


### deployedRouters

```solidity
address[] public deployedRouters;
```


### protocolRouter

```solidity
address public protocolRouter;
```


### sherryFoundationAddress

```solidity
address public sherryFoundationAddress;
```


### sherryTreasuryAddress

```solidity
address public sherryTreasuryAddress;
```


### kolFeeRate

```solidity
uint16 public kolFeeRate = 100;
```


### foundationFeeRate

```solidity
uint16 public foundationFeeRate = 50;
```


### treasuryFeeRate

```solidity
uint16 public treasuryFeeRate = 50;
```


### BASIS_POINTS

```solidity
uint16 public constant BASIS_POINTS = 10000;
```


## Functions
### constructor

*Constructor*


```solidity
constructor(address _protocolRouter, address _sherryFoundationAddress, address _sherryTreasuryAddress)
    Ownable(msg.sender);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_protocolRouter`|`address`|Address of the protocol's router|
|`_sherryFoundationAddress`|`address`|Address of Sherry Foundation|
|`_sherryTreasuryAddress`|`address`|Address of Sherry Treasury|


### setProtocolRouter

*Updates the protocol router address*


```solidity
function setProtocolRouter(address _protocolRouter) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_protocolRouter`|`address`|New router address|


### setSherryFoundationAddress

*Updates the Sherry Foundation address*


```solidity
function setSherryFoundationAddress(address _sherryFoundationAddress) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_sherryFoundationAddress`|`address`|New foundation address|


### setSherryTreasuryAddress

*Updates the Sherry Treasury address*


```solidity
function setSherryTreasuryAddress(address _sherryTreasuryAddress) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_sherryTreasuryAddress`|`address`|New foundation address|


### setFeeRates

*Updates the fee rates*


```solidity
function setFeeRates(uint16 _kolFeeRate, uint16 _foundationFeeRate, uint16 _treasuryFeeRate) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_kolFeeRate`|`uint16`|New KOL fee rate in basis points|
|`_foundationFeeRate`|`uint16`|New foundation fee rate in basis points|
|`_treasuryFeeRate`|`uint16`||


### getTotalRouters

*Gets the total number of deployed routers of all Kols*


```solidity
function getTotalRouters() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Number of routers|


### getKOLRouter

*Gets the KOL router by index*


```solidity
function getKOLRouter(address _kolAddress, uint256 _index) external view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_kolAddress`|`address`|KOL address|
|`_index`|`uint256`|Router index|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|Router address by index|


### getKOLRoutersCount

*Gets the KOL's routers count*


```solidity
function getKOLRoutersCount(address _kolAddress) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_kolAddress`|`address`|KOL address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|KOL's number of routers|


### createKOLRouter

*Creates a KOL router and handles common registration logic*


```solidity
function createKOLRouter(address _kolAddress) external returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_kolAddress`|`address`|KOL address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|routerAddress Address of the new router|


### _createRouterImplementation

*Abstract method to create the specific router implementation
Must be implemented by derived contracts*


```solidity
function _createRouterImplementation(address kolAddress) internal virtual returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`kolAddress`|`address`|Address of the KOL|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|Router address|


### getKOLFeeRate

*Getter functions for fee configuration (used by routers)*


```solidity
function getKOLFeeRate() external view returns (uint16);
```

### getFoundationFeeRate


```solidity
function getFoundationFeeRate() external view returns (uint16);
```

### getTreasuryFeeRate


```solidity
function getTreasuryFeeRate() external view returns (uint16);
```

### getTotalFeeRate


```solidity
function getTotalFeeRate() external view returns (uint16);
```

### getBasisPoints


```solidity
function getBasisPoints() external pure returns (uint16);
```

## Events
### RouterCreated

```solidity
event RouterCreated(address indexed kolAddress, address routerAddress);
```

### ProtocolAddressUpdated

```solidity
event ProtocolAddressUpdated(address routerAddress);
```

### FoundationAddressUpdated

```solidity
event FoundationAddressUpdated(address foundationAddress);
```

### TreasuryAddressUpdated

```solidity
event TreasuryAddressUpdated(address foundationAddress);
```

### FeeRatesUpdated

```solidity
event FeeRatesUpdated(uint16 kolFeeRate, uint16 foundationFeeRate, uint16 treasuryFeeRate);
```

