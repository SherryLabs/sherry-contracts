# Sherry
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/0397b52a9122a39e14e9d4b74fb341f977b54dd3/src/Sherry.sol)

**Inherits:**
Ownable


## State Variables
### i_brandContract

```solidity
IBrand public i_brandContract;
```


### i_campaignContract

```solidity
ICampaign public i_campaignContract;
```


### i_kolContract

```solidity
IKOL public i_kolContract;
```


## Functions
### constructor


```solidity
constructor(address _brandContract, address _campaignContract, address _kolContract) Ownable(msg.sender);
```

