# ISherry
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/4825c77c24e2a3747feff5968c1175f48f09a0aa/src/interface/ISherry.sol)

This interface defines the structure and events for the Sherry contract.

*This interface includes functions for creating posts, voting, and retrieving URIs.*


## Functions
### createPost

Creates a new post.


```solidity
function createPost(uint256 _idKolCampaign, string memory _url) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idKolCampaign`|`uint256`|The ID of the KOL campaign.|
|`_url`|`string`|The URL of the post.|


### vote

Casts a vote on a post.


```solidity
function vote(uint256 _idPost) external returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idPost`|`uint256`|The ID of the post to vote on.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|A boolean indicating whether the vote was successful.|


### getUri

Retrieves the URI of a post.


```solidity
function getUri(uint256 _idPost) external view returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idPost`|`uint256`|The ID of the post.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|The URI of the post as a string.|


## Events
### Voted
*Emitted when a vote is cast on a post.*


```solidity
event Voted(uint256 indexed idPost, address indexed voter);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`idPost`|`uint256`|The ID of the post that was voted on.|
|`voter`|`address`|The address of the voter.|

### PostCreated
*Emitted when a new post is created.*


```solidity
event PostCreated(uint256 indexed idPost, address indexed kol, uint256 indexed idCampaign, string url);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`idPost`|`uint256`|The ID of the newly created post.|
|`kol`|`address`|The address of the Key Opinion Leader (KOL) who created the post.|
|`idCampaign`|`uint256`|The ID of the campaign associated with the post.|
|`url`|`string`|The URL of the post.|

## Structs
### Post
Represents a post in the Sherry contract.


```solidity
struct Post {
    uint256 idKolCampaign;
    address kol;
    uint256 idCampaign;
    string url;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`idKolCampaign`|`uint256`|The ID of the KOL campaign.|
|`kol`|`address`|The address of the KOL.|
|`idCampaign`|`uint256`|The ID of the campaign.|
|`url`|`string`|The URL associated with the post.|

