# SherryPeerToken
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/ac3659d9daf69f5807477dfb4ad35c396dc00c1f/contracts/wormhole/SherryPeerToken.sol)

**Inherits:**
[BaseToken](/contracts/lib/BaseToken.sol/contract.BaseToken.md), ERC20Burnable, Ownable


## State Variables
### minter

```solidity
address public minter;
```


## Functions
### onlyMinter


```solidity
modifier onlyMinter();
```

### constructor


```solidity
constructor(string memory _name, string memory _symbol, address _minter, address _owner)
    BaseToken(_name, _symbol)
    Ownable(_owner);
```

### mint


```solidity
function mint(address _account, uint256 _amount) external onlyMinter;
```

### setMinter


```solidity
function setMinter(address newMinter) external onlyOwner;
```

### _update


```solidity
function _update(address _from, address _to, uint256 _value) internal override(ERC20, BaseToken);
```

## Events
### NewMinter

```solidity
event NewMinter(address newMinter);
```

## Errors
### CallerNotMinter

```solidity
error CallerNotMinter(address caller);
```

### InvalidMinterZeroAddress

```solidity
error InvalidMinterZeroAddress();
```

