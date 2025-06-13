# BaseToken
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/390adef083cf3e2fd6de18cb4a729a02cfd3c226/contracts/lib/BaseToken.sol)

**Inherits:**
ERC20, ERC20Permit, ERC20Votes


## State Variables
### MAX_SUPPLY

```solidity
uint256 public constant MAX_SUPPLY = 10_000_000_000e18;
```


## Functions
### constructor


```solidity
constructor(string memory _name, string memory _symbol) ERC20Permit(_name) ERC20(_name, _symbol);
```

### clock


```solidity
function clock() public view virtual override returns (uint48);
```

### CLOCK_MODE


```solidity
function CLOCK_MODE() public view virtual override returns (string memory);
```

### _maxSupply


```solidity
function _maxSupply() internal pure override returns (uint256);
```

### nonces


```solidity
function nonces(address _owner) public view override(ERC20Permit, Nonces) returns (uint256);
```

### _update


```solidity
function _update(address _from, address _to, uint256 _value) internal virtual override(ERC20, ERC20Votes);
```

