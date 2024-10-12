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
- `updateBrand(string memory _name, address _brandOwner, uint256 _idBrand)`: Actualiza una marca existente.
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

Para desplegarlos y verificarlos puedes ejecutar

### Local 

```shell
npx hardhat ignition deploy ignition/modules/SherryProtocol.ts
```

### Testnet

```shell
npx hardhat ignition deploy ignition/modules/SherryProtocol.ts --network baseSepolia --verify
```

## Metadata Posts 

```json
{
  "name": "Post Sherry v1.0",
  "image": "https://ipfs.io/IPFS_HASH",
  "description": "Este es mi primer post",
  "external_url": "https://getsherry.link/sd8745",
  "attributes": [
    {
      "trait_type": "Network",
      "value": "Instagram"
    },
    {
      "trait_type": "Content Type",
      "value": "Post"
    }
  ]
}
```

### Atributos

| **Campo**        | **Descripción**                                           |
|--------------|-------------------------------------------------------|
| `name`         | Nombre del post.                                      |
| `image`        | URL de la imagen del post almacenada en IPFS.         |
| `description`  | Descripción del post.                                 |
| `external_url` | URL externa asociada al post.                         |
| `attributes`   | Atributos adicionales del post, como la red social y el tipo de contenido. |

| **Atributo**     | **Valor**       |
|--------------|-------------|
| `Network`      | Instagram   |
| `Content Type` | Post        |

### Descripción de los Campos

- **name**: El nombre del post, en este caso "Post Sherry v1.0".
- **image**: La URL de la imagen del post, almacenada en IPFS.
- **description**: Una breve descripción del post.
- **external_url**: Un enlace externo asociado al post.
- **attributes**: Una lista de atributos adicionales que describen el post, como la red social en la que se publicó y el tipo de contenido.

## Addresses Contratos

### Base Mainnet

| **Contrato** | **Dirección** |
|----------|-----------|
| `Brand`    | null |
| `Campaign` | null |
| `KOL`      | null |
| `Sherry`   | null |

### Base Sepolia

| **Contrato** | **Dirección** |
|----------|-----------|
| `Brand`    | 0xD9aEE67370E158faC0904C6e9F0bb3D967C135C4 |
| `Campaign` | 0xc9188127359280EF92C643701c3E30DFd2aa1dE0 |
| `KOL`      | 0xa381f12C079ed5382D1630C1467d32bd821501f5 |
| `Sherry`   | 0xBf0984EFd4e04540b1814cdf3FC890728fEC4652 |

## Seed Contract

Para inicializar los contratos con datos de prueba, puedes utilizar los siguientes comandos:

```shell
npx hardhat run scripts/seed.ts
```

Para inicializar los contratos en la red Base Sepolia, utiliza:

```shell
npx hardhat run scripts/seed.ts --network baseSepolia
```

Estos scripts se encargan de poblar los contratos con datos iniciales necesarios para su funcionamiento.