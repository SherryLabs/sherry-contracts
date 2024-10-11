# CheckSender
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/250890a0c8afb7b7382121b0d8e526c798b0670c/src/CheckSender.sol)


## State Variables
### lastSender

```solidity
address public lastSender;
```


### lastOrigin

```solidity
address public lastOrigin;
```


## Functions
### checkSender


```solidity
function checkSender() public;
```

## Events
### Log

```solidity
event Log(address indexed sender, bytes data);
```

