# KOLFactoryBase
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/7488ae397dbcaa4df700f0dbbfff7f6537916c5a/contracts/kol-router/KOLFactoryBase.sol)

**Inherits:**
Ownable

*Abstract base contract for protocol-specific KOL router factories*


## State Variables
### kolToRouter

```solidity
mapping(address => address) public kolToRouter;
```


### deployedRouters

```solidity
address[] public deployedRouters;
```


### protocolRouter

```solidity
address public protocolRouter;
```


## Functions
### constructor

*Constructor*


```solidity
constructor(address _protocolRouter) Ownable(msg.sender);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_protocolRouter`|`address`|Address of the protocol's router|


### setProtocolRouter

*Updates the protocol router address*


```solidity
function setProtocolRouter(address _protocolRouter) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_protocolRouter`|`address`|New router address|


### getTotalRouters

*Gets the total number of deployed routers*


```solidity
function getTotalRouters() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Number of routers|


### getKOLRouter

*Gets a KOL's router*


```solidity
function getKOLRouter(address kolAddress) external view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`kolAddress`|`address`|KOL address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|Router address|


### createKOLRouter

*Creates a KOL router and handles common registration logic*


```solidity
function createKOLRouter(address kolAddress, uint256 _fixedFeeAmount) external returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`kolAddress`|`address`|KOL address|
|`_fixedFeeAmount`|`uint256`|Amount to be subtracted as Fee|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|routerAddress Address of the new router|


### _createRouterImplementation

*Abstract method to create the specific router implementation
Must be implemented by derived contracts*


```solidity
function _createRouterImplementation(address kolAddress, uint256 _fixedFeeAmount) internal virtual returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`kolAddress`|`address`|Address of the KOL|
|`_fixedFeeAmount`|`uint256`|Amount to be subtracted as Fee|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|Router address|


## Events
### RouterCreated

```solidity
event RouterCreated(address indexed kolAddress, address routerAddress);
```

### ProtocolAddressUpdated

```solidity
event ProtocolAddressUpdated(address routerAddress);
```

