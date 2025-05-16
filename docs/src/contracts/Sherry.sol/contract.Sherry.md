# Sherry
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/abea0d8e26a21a2127d6a1d9e961e252da35642b/contracts/Sherry.sol)

**Inherits:**
Ownable, Pausable

A contract that allows execution of function calls on other contracts

*Acts as a proxy contract to execute functions on other contracts*


## State Variables
### MIN_DATA_LENGTH
Minimum call data length (4 bytes for function selector)


```solidity
uint256 public constant MIN_DATA_LENGTH = 4;
```


## Functions
### sendMessage

Executes a function call on another contract

*Requires a minimum transaction fee to be paid*


```solidity
function sendMessage(address _contractToBeCalled, bytes memory _encodedFunctionCall) public payable whenNotPaused;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_contractToBeCalled`|`address`|The address of the contract to call|
|`_encodedFunctionCall`|`bytes`|The encoded function call data to execute|


### _getRevertMsg

Extracts the revert message from return data

*Internal function to parse revert messages*


```solidity
function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_returnData`|`bytes`|The return data from a failed call|


### pause

Allows owner to pause contract functionality


```solidity
function pause() external onlyOwner;
```

### unpause

Allows owner to unpause contract functionality


```solidity
function unpause() external onlyOwner;
```

### receive

Prevents ETH from being stuck in the contract


```solidity
receive() external payable;
```

## Events
### FunctionExecuted
Event emitted when a function is successfully executed


```solidity
event FunctionExecuted(address indexed contractToBeCalled, bytes encodedFunctionCall);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`contractToBeCalled`|`address`|The address of the contract that was called|
|`encodedFunctionCall`|`bytes`|The encoded function call data that was executed|

### FunctionFailed
Event emitted when a function execution fails


```solidity
event FunctionFailed(address indexed contractToBeCalled, bytes encodedFunctionCall, string reason);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`contractToBeCalled`|`address`|The address of the contract that was called|
|`encodedFunctionCall`|`bytes`|The encoded function call data that failed|
|`reason`|`string`|The reason for the failure|

