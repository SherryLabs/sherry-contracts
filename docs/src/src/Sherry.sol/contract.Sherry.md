# Sherry
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/4825c77c24e2a3747feff5968c1175f48f09a0aa/src/Sherry.sol)

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


### idPost

```solidity
uint256 public idPost;
```


### posts

```solidity
Post[] public posts;
```


### s_posts

```solidity
mapping(uint256 => Post) public s_posts;
```


### s_votesFollowers

```solidity
mapping(uint256 => mapping(address => bool)) public s_votesFollowers;
```


### s_votes

```solidity
mapping(uint256 => uint256) public s_votes;
```


### s_votesByCampaign

```solidity
mapping(uint256 => mapping(address => bool)) public s_votesByCampaign;
```


## Functions
### constructor


```solidity
constructor(address _brandContract, address _campaignContract, address _kolContract) Ownable(msg.sender);
```

### createPost


```solidity
function createPost(uint256 _idKolCampaign, string memory _url) external;
```

### vote


```solidity
function vote(uint256 _idPost, address _voter) external returns (bool);
```

### getUri


```solidity
function getUri(uint256 _idPost) public view returns (string memory);
```

## Events
### Voted

```solidity
event Voted(uint256 indexed idPost, address indexed voter);
```

### PostCreated

```solidity
event PostCreated(uint256 indexed idPost, address indexed kol, uint256 indexed idCampaign, string url);
```

## Structs
### Post

```solidity
struct Post {
    uint256 idKolCampaign;
    address kol;
    uint256 idCampaign;
    string url;
}
```

