# CCIPSenderMiniApp
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/7488ae397dbcaa4df700f0dbbfff7f6537916c5a/contracts/examples/CCIPSender.sol)


## State Variables
### s_linkToken

```solidity
IERC20 private s_linkToken;
```


### s_router

```solidity
IRouterClient private s_router;
```


### s_destinationChainSelector

```solidity
uint64 public constant s_destinationChainSelector = 16281711391670634445;
```


## Functions
### constructor


```solidity
constructor(address _router, address _link);
```

### transferUSDC


```solidity
function transferUSDC(address _receiver, address _token, uint256 _amount) external returns (bytes32 messageId);
```

### _buildCCIPMessage


```solidity
function _buildCCIPMessage(address _receiver, address _token, uint256 _amount, address _feeTokenAddress)
    private
    pure
    returns (Client.EVM2AnyMessage memory);
```

### receive


```solidity
receive() external payable;
```

