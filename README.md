# SL1 Smart Contracts - Avalanche Summit Hackathon

## SL1Sender.sol

Este contrato se utiliza para enviar cualquier mensaje a cualquier L1. Permite ejecutar cualquier función en cualquiera de estas L1s.

### Main Function - `sendMessage`

```solidity

function sendMessage(
        address _destinationContract,
        bytes4 _functionSig,
        bytes memory _params,
        bytes32 _destinationChain,
        uint256 _gasLimit
    ) public { }
```

#### Descripción de la función

La función `sendMessage` permite enviar un mensaje codificado a través de un protocolo cross-chain para ejecutar una función específica en un contrato de destino en otra blockchain.

#### Parámetros

- `address _destinationContract`: La dirección del contrato en la blockchain de destino donde se ejecutará la función.
- `bytes4 _functionSig`: La firma de la función que se desea ejecutar en el contrato de destino. Esta firma se obtiene utilizando abi.encodeWithSignature.

- `bytes memory _params`: Los parámetros codificados que se pasarán a la función del contrato de destino. Estos parámetros deben estar codificados utilizando abi.encode.

- `bytes32 _destinationChain`: El identificador de la blockchain de destino. Este identificador es específico del protocolo cross-chain que se esté utilizando.

- `uint256 _gasLimit`: El límite de gas que se asignará para la ejecución de la función en la blockchain de destino. Este valor debe ser suficiente para cubrir el costo de la ejecución de la función.

#### Ejemplo de Uso

```solidity
address destinationContract = 0x1234567890abcdef1234567890abcdef12345678;
bytes4 functionSig = bytes4(keccak256("someFunction(uint256,address)"));
bytes memory params = abi.encode(42, 0xabcdefabcdefabcdefabcdefabcdefabcdef);
bytes32 destinationChain = 0xabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdef;
uint256 gasLimit = 200000;

SL1Sender.sendMessage(destinationContract, functionSig, params, destinationChain, gasLimit);
```

En este ejemplo, se envía un mensaje para ejecutar la función `someFunction` en el contrato de destino con los parámetros `42` y `0xabcdefabcdefabcdefabcdefabcdefabcdef`. El mensaje se envía a la blockchain de destino especificada por `destinationChain` con un límite de gas de `200000`.

Este enfoque permite una comunicación flexible y dinámica entre contratos en diferentes blockchains, facilitando la interoperabilidad cross-chain.


