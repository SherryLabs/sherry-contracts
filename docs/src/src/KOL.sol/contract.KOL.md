# KOL
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/3bf09ae64235cad3c49f973ecfe9d2e4b7b5f336/src/KOL.sol)

**Inherits:**
Ownable


## State Variables
### s_campaignContract

```solidity
Campaign public s_campaignContract;
```


### idKolCampaign

```solidity
uint256 public idKolCampaign;
```


### s_kols

```solidity
mapping(address => bool) public s_kols;
```


### s_kolCampaign

```solidity
mapping(uint256 => KOLCampaign) public s_kolCampaign;
```


### s_campaignsKol

```solidity
mapping(address => KOLCampaign[]) public s_campaignsKol;
```


## Functions
### constructor


```solidity
constructor(address _campaignContract) Ownable(msg.sender);
```

### addKol


```solidity
function addKol(address _address) external onlyOwner;
```

### addKolToCampaign


```solidity
function addKolToCampaign(uint256 _idCampaign) external;
```

### updateCampaignContract


```solidity
function updateCampaignContract(address _campaignContract) external onlyOwner;
```

### getKOLCampaign


```solidity
function getKOLCampaign(uint256 _id) public view returns (address, uint256);
```

### getKolCampaignsByAddress


```solidity
function getKolCampaignsByAddress(address _kol) public view returns (KOLCampaign[] memory);
```

### isValidKolCampaign


```solidity
function isValidKolCampaign(uint256 _id) public view returns (bool);
```

## Events
### KolCampaignAdded

```solidity
event KolCampaignAdded(uint256 indexed idKolCampaign, address indexed kol, uint256 idCampaign);
```

## Structs
### KOLCampaign

```solidity
struct KOLCampaign {
    address kol;
    uint256 idCampaign;
}
```

