# IKOL
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/7b458adc8d15d374ad0b668358409374cba45ea7/src/interface/IKOL.sol)

Interface para la gestión de KOLs y sus campañas.

*Define las funciones necesarias para agregar KOLs y asignarlos a campañas.*


## Functions
### joinAsKol

Agrega un nuevo KOL.


```solidity
function joinAsKol(address _address) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|Dirección del KOL.|


### addKolToCampaign

Asigna un KOL a una campaña.


```solidity
function addKolToCampaign(uint256 _idCampaign) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idCampaign`|`uint256`|Identificador de la campaña.|


### isKol

Verifica si una dirección es un KOL válido.


```solidity
function isKol(address _address) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|Dirección a verificar.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Booleano que indica si la dirección es un KOL válido.|


### getCampaignsByKol

Obtiene las campañas asociadas a un KOL.


```solidity
function getCampaignsByKol(address _kol) external view returns (KOLCampaign[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_kol`|`address`|Dirección del KOL.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`KOLCampaign[]`|Array de estructuras KOLCampaign asociadas al KOL.|


### getKOLCampaign


```solidity
function getKOLCampaign(uint256 _id) external view returns (address, uint256);
```

## Events
### KolCampaignAdded
Evento emitido cuando se agrega una campaña de KOL.


```solidity
event KolCampaignAdded(uint256 indexed idKolCampaign, address indexed kol, uint256 idCampaign);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`idKolCampaign`|`uint256`|Identificador único de la campaña de KOL.|
|`kol`|`address`|Dirección del KOL.|
|`idCampaign`|`uint256`|Identificador de la campaña.|

## Structs
### KOLCampaign
Estructura que representa una campaña de KOL.


```solidity
struct KOLCampaign {
    address kol;
    uint256 idCampaign;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`kol`|`address`|Dirección del KOL.|
|`idCampaign`|`uint256`|Identificador de la campaña.|

