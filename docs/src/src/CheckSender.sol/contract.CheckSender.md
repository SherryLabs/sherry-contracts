# CheckSender
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/9d26903f83c0635ecf45d14ba507282d6c274a85/src/CheckSender.sol)


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

