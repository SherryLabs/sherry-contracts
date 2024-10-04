# Sherry
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/232bf9efe0767602403653d7a237c047730044fe/src/Sherry.sol)

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

