# Campaign
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/09d6263aefcffa8d872e75c7801f76e7deb5685b/src/Campaign.sol)

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


## Functions
### constructor


```solidity
constructor(address _brandContract) Ownable(msg.sender);
```

### createCampaign


```solidity
function createCampaign(uint256 _idBrand, string memory _name, uint256 _amount, uint256 _startDate, uint256 _endDate)
    external
    onlyOwner;
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

