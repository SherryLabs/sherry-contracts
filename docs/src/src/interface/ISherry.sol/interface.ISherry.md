# ISherry
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/7b458adc8d15d374ad0b668358409374cba45ea7/src/interface/ISherry.sol)

Interface para la gestión de enlaces y votaciones.

*Define las funciones y eventos necesarios para crear enlaces y votar en ellos.*


## Functions
### createLink

Crea un nuevo enlace asociado a una campaña de KOL.


```solidity
function createLink(uint256 _idKolCampaign, string memory _url) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idKolCampaign`|`uint256`|Identificador de la campaña de KOL.|
|`_url`|`string`|URL del enlace a crear.|


### vote

Permite a un usuario votar en un enlace.


```solidity
function vote(uint256 _idLink) external returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idLink`|`uint256`|Identificador del enlace a votar.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Booleano que indica si el voto fue exitoso.|


## Events
### Voted
Evento emitido cuando un usuario vota en un enlace.


```solidity
event Voted(uint256 indexed idLink, address indexed voter);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`idLink`|`uint256`|Identificador del enlace votado.|
|`voter`|`address`|Dirección del usuario que votó.|

### LinkCreated
Evento emitido cuando se crea un nuevo enlace.


```solidity
event LinkCreated(uint256 indexed idLink, address indexed kol, uint256 indexed idCampaign, string url);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`idLink`|`uint256`|Identificador del nuevo enlace.|
|`kol`|`address`|Dirección del KOL asociado al enlace.|
|`idCampaign`|`uint256`|Identificador de la campaña asociada al enlace.|
|`url`|`string`|URL del enlace creado.|

