# KOL
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/7b458adc8d15d374ad0b668358409374cba45ea7/src/KOL.sol)

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

### joinAsKol


```solidity
function joinAsKol(address _address) external;
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

