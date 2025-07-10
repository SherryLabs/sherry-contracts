# SL1TokenReceiver
[Git Source](https://github.com-smastropiero/SherryLabs/sherry-contracts/blob/ac3659d9daf69f5807477dfb4ad35c396dc00c1f/contracts/wormhole/SL1.TokenReceiver.sol)

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

