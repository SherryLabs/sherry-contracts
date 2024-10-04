# KOL
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/232bf9efe0767602403653d7a237c047730044fe/src/KOL.sol)

**Inherits:**
Ownable


## State Variables
### s_campaignContract

```solidity
Campaign public s_campaignContract;
```


### idLink

```solidity
uint256 public idLink;
```


### idKOLCampaign

```solidity
uint256 public idKOLCampaign;
```


### s_kols

```solidity
mapping(address => bool) public s_kols;
```


### s_links

```solidity
mapping(uint256 => Link) public s_links;
```


### s_kolCampaigns

```solidity
mapping(uint256 => mapping(address => KOLCampaign)) public s_kolCampaigns;
```


### s_votesFollowers

```solidity
mapping(uint256 => mapping(address => bool)) public s_votesFollowers;
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
function addKolToCampaign(uint256 _idCampaign) external onlyOwner;
```

### createLink


```solidity
function createLink(uint256 _idKolCampaign, string memory _link) external;
```

### vote


```solidity
function vote(uint256 _idLink) external returns (bool);
```

### updateCampaignContract


```solidity
function updateCampaignContract(address _campaignContract) external onlyOwner;
```

## Events
### Voted

```solidity
event Voted(uint256 indexed idLink, address indexed voter);
```

### LinkCreated

```solidity
event LinkCreated(uint256 idLink, uint256 idKOL, uint256 idCampaign, string link);
```

## Structs
### KOLCampaign

```solidity
struct KOLCampaign {
    address kol;
    uint256 idCampaign;
}
```

### Link

```solidity
struct Link {
    address kol;
    uint256 idCampaign;
    string link;
}
```

