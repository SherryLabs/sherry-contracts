# Sherry
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/09d6263aefcffa8d872e75c7801f76e7deb5685b/src/Sherry.sol)

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


### idLink

```solidity
uint256 public idLink;
```


### s_links

```solidity
mapping(uint256 => Link) public s_links;
```


### s_votesFollowers

```solidity
mapping(uint256 => mapping(address => bool)) public s_votesFollowers;
```


## Functions
### constructor


```solidity
constructor(address _brandContract, address _campaignContract, address _kolContract) Ownable(msg.sender);
```

### createLink


```solidity
function createLink(uint256 _idKolCampaign, string memory _url) external;
```

### vote


```solidity
function vote(uint256 _idLink) external returns (bool);
```

## Events
### Voted

```solidity
event Voted(uint256 indexed idLink, address indexed voter);
```

### LinkCreated

```solidity
event LinkCreated(uint256 indexed idLink, address indexed kol, uint256 indexed idCampaign, string url);
```

## Structs
### Link

```solidity
struct Link {
    uint256 idKolCampaign;
    address kol;
    uint256 idCampaign;
    string url;
}
```

