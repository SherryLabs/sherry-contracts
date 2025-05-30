# IUniversalRouter
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/42c75427de405d6510851a4525799e04cd6d3130/src/kol-router/interfaces/IUniversalRouter.sol)


## Functions
### execute

Executes encoded commands along with provided inputs. Reverts if deadline has expired.


```solidity
function execute(bytes calldata commands, bytes[] calldata inputs, uint256 deadline) external payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`commands`|`bytes`|A set of concatenated commands, each 1 byte in length|
|`inputs`|`bytes[]`|An array of byte strings containing abi encoded inputs for each command|
|`deadline`|`uint256`|The deadline by which the transaction must be executed|


## Errors
### ExecutionFailed
Thrown when a required command has failed


```solidity
error ExecutionFailed(uint256 commandIndex, bytes message);
```

### ETHNotAccepted
Thrown when attempting to send ETH directly to the contract


```solidity
error ETHNotAccepted();
```

### TransactionDeadlinePassed
Thrown when executing commands with an expired deadline


```solidity
error TransactionDeadlinePassed();
```

### LengthMismatch
Thrown when attempting to execute commands and an incorrect number of inputs are provided


```solidity
error LengthMismatch();
```

### InvalidEthSender

```solidity
error InvalidEthSender();
```

