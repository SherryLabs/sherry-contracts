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

### Base Mainnet

| Contrato | Dirección |
|----------|-----------|
| Brand    | null |
| Campaign | null |
| KOL      | null |
| Sherry   | null |

### Base Sepolia

| Contrato | Dirección |
|----------|-----------|
| Brand    | 0x7F895FB1aFBce37f1eeb94e1A273542De657FeEE |
| Campaign | 0x36285B0876E0B45771C5c76885B35d4FE5b39b10 |
| KOL      | 0x21fb3E1D7a7a218fdd9C28b0b18D8b9Cb49Fe259 |
| Sherry   | 0x0914b8a17412F59f7240Fbd8bE753586fceA48a0 |