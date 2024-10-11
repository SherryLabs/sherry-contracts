# Campaign
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/250890a0c8afb7b7382121b0d8e526c798b0670c/src/Campaign.sol)

**Inherits:**
Ownable


## State Variables
### s_brandContract

```solidity
IBrand public s_brandContract;
```


### idCampaign

```solidity
uint256 public idCampaign;
```


### s_campaigns

```solidity
mapping(uint256 => CampaignStruct) public s_campaigns;
```


### s_uriCampaign

```solidity
mapping(uint256 => string) public s_uriCampaign;
```


## Functions
### constructor


```solidity
constructor(address _brandContract) Ownable(msg.sender);
```

### createCampaign


```solidity
function createCampaign(
    uint256 _idBrand,
    string memory _name,
    uint256 _amount,
    uint256 _startDate,
    uint256 _endDate,
    string memory _uri
) external onlyOwner;
```

### updateCampaign


```solidity
function updateCampaign(uint256 _idCampaign, string memory _name, uint256 _amount, uint256 _startDate, uint256 _endDate)
    external;
```

### getCampaignById


```solidity
function getCampaignById(uint256 _idCampaign)
    external
    view
    returns (uint256, uint256, string memory, uint256, bool, uint256, uint256);
```

### isValidCampaign


```solidity
function isValidCampaign(uint256 _idCampaign) public view returns (bool);
```

### getUriCampaign


```solidity
function getUriCampaign(uint256 _idCampaign) public view returns (string memory);
```

## Events
### CampaignCreated

```solidity
event CampaignCreated(
    uint256 indexed idCampaign,
    uint256 indexed idBrand,
    string name,
    uint256 amount,
    uint256 startDate,
    uint256 endDate,
    string uri
);
```

### CampaignUpdated

```solidity
event CampaignUpdated(uint256 indexed idCampaign, string name, uint256 amount);
```

## Structs
### CampaignStruct

```solidity
struct CampaignStruct {
    uint256 idCampaign;
    uint256 idBrand;
    string name;
    uint256 amount;
    bool active;
    uint256 startDate;
    uint256 endDate;
}
```

