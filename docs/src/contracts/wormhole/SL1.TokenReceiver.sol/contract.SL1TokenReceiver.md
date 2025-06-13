# SL1TokenReceiver
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/390adef083cf3e2fd6de18cb4a729a02cfd3c226/contracts/wormhole/SL1.TokenReceiver.sol)

**Inherits:**
TokenReceiver


## Functions
### constructor


```solidity
constructor(address _wormholeRelayer, address _tokenBridge, address _wormhole)
    TokenBase(_wormholeRelayer, _tokenBridge, _wormhole);
```

### receivePayloadAndTokens


```solidity
function receivePayloadAndTokens(
    bytes memory _payload,
    TokenReceived[] memory _tokens,
    bytes32 _sourceAddress,
    uint16 _sourceChain,
    bytes32
) internal override onlyWormholeRelayer isRegisteredSender(_sourceChain, _sourceAddress);
```

