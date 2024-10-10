# CheckSender
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/4825c77c24e2a3747feff5968c1175f48f09a0aa/src/CheckSender.sol)


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

