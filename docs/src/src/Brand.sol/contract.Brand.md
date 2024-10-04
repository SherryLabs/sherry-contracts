# Brand
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/0397b52a9122a39e14e9d4b74fb341f977b54dd3/src/Brand.sol)

**Inherits:**
Ownable


## State Variables
### idBrand

```solidity
uint256 public idBrand;
```


### brands

```solidity
mapping(uint256 => BrandStruct) public brands;
```


### brandOperators

```solidity
mapping(uint256 => address) public brandOperators;
```


## Functions
### constructor


```solidity
constructor() Ownable(msg.sender);
```

### createBrand


```solidity
function createBrand(string memory _name, address _brandOwner) external onlyOwner;
```

### updateBrand


```solidity
function updateBrand(string memory _name, address _brandOwner, uint256 _idBrand) external isOperatorOrOwner(_idBrand);
```

### disableBrand


```solidity
function disableBrand(uint256 _idBrand) external onlyOwner;
```

### enableBrand


```solidity
function enableBrand(uint256 _idBrand) external onlyOwner;
```

### getBrand


```solidity
function getBrand(uint256 _idBrand) public view returns (uint256, address, string memory, bool);
```

### isValidBrand


```solidity
function isValidBrand(uint256 _idBrand) public view returns (bool);
```

### isOperatorOrOwner


```solidity
modifier isOperatorOrOwner(uint256 _idBrand);
```

## Structs
### BrandStruct

```solidity
struct BrandStruct {
    uint256 idBrand;
    address brandOwner;
    string name;
    bool active;
}
```

