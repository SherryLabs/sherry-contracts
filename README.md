# Sherry Contracts

**Sherry Contracts** es un proyecto de contratos inteligentes para la gestión de marcas y campañas en la blockchain de Ethereum. Utiliza Foundry como toolkit para el desarrollo, pruebas y despliegue de contratos inteligentes.

## Herramientas Utilizadas

El proyecto utiliza las siguientes herramientas de Foundry:

- **Forge**: Framework de pruebas para Ethereum.
- **Cast**: Herramienta multifuncional para interactuar con contratos inteligentes EVM, enviar transacciones y obtener datos de la cadena.
- **Anvil**: Nodo local de Ethereum, similar a Ganache o Hardhat Network.
- **Chisel**: REPL de Solidity rápido y utilitario.

## Documentación

Puedes encontrar la documentación completa de Foundry en el siguiente enlace:
[Foundry Book](https://book.getfoundry.sh/)

## Uso

### Construir

Para compilar los contratos inteligentes, utiliza el siguiente comando:

```shell
forge build
```

### Probar

Para ejecutar las pruebas de los contratos inteligentes, utiliza el siguiente comando:

```shell
forge test
```

## Contratos

### Brand.sol

El contrato Brand gestiona las marcas en la blockchain. Permite crear, actualizar, obtener y validar marcas.

- `createBrand(string memory _name, address _brandOwner)`: Crea una nueva marca.
- `updateBrand(string memory _name, address _brandOwner, uint256 _idBrand)`: - Actualiza una marca existente.
- `getBrand(uint256 _idBrand)`: Obtiene los detalles de una marca.
- `disableBrand(uint256 _idBrand)`: Desactiva una marca.
- `enableBrand(uint256 _idBrand)`: Activa una marca.
- `isValidBrand(uint256 _idBrand)`: Verifica si una marca es válida.

### Campaign.sol

El contrato Campaign gestiona las campañas asociadas a las marcas. Permite crear y actualizar campañas.

- `createCampaign(uint256 _idBrand, string memory _name, uint256 _amount, uint256 _startDate, uint256 _endDate)`: Crea una nueva campaña.
- `updateCampaign(uint256 _idCampaign, string memory _name, uint256 _amount, uint256 _startDate, uint256 _endDate)`: Actualiza una campaña existente.

## Pruebas

Las pruebas se encuentran en la carpeta `test` y utilizan el framework de pruebas de Foundry (`Forge`). Para ejecutar las pruebas, utiliza el siguiente comando:

```shell
forge test
```

## Despliegue

Para desplegar los contratos en una red de EVM Compatible, puedes utilizar herramientas como `hardhat-ignition` o `scripts` personalizados. Asegúrate de configurar las direcciones y parámetros necesarios en los scripts de despliegue.

En el caso de `Sherry` podrás encontrar la configuración de despliegue en el folder `ignition/modules`

## Addresses Contratos

### Base Sepolia

| Contrato | Dirección |
|----------|-----------|
| Brand    | 0xa3CA6021b432a88EEFb5b53B31833e19195b4ecB |
| Campaign | 0x5aDDD36200C7Df43Ee655c872f40B460f7056f8d |
| KOL      | 0x22bf4Be375941853e42ce559258362819b7ee637 |
| Sherry   | 0xE46b6b941BbBf93be4D422C96aaf4749CAf9a386 |