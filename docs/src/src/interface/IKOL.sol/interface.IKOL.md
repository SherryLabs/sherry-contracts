# IKOL
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/2fd4840f6f8521f3419b23a60a2607a11251a45b/src/interface/IKOL.sol)


## Functions
### createKOL


```solidity
function createKOL(string memory _name, address _kolOwner) external;
```

### updateKOL


```solidity
function updateKOL(string memory _name, address _kolOwner, uint256 _idKOL) external;
```

### disableKOL


```solidity
function disableKOL(uint256 _idKOL) external;
```

### getKOLCampaign


```solidity
function getKOLCampaign(uint256 _id) external returns (address, uint256);
```

### enableKOL


```solidity
function enableKOL(uint256 _idKOL) external;
```

### isValidKolCampaign


```solidity
function isValidKolCampaign(uint256 _id) external returns (bool isValid);
```

