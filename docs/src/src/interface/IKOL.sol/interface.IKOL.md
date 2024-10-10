# IKOL
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/4825c77c24e2a3747feff5968c1175f48f09a0aa/src/interface/IKOL.sol)

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
*Emitted when a new KolCampaign is added.*


```solidity
event KolCampaignAdded(uint256 indexed idKolCampaign, address indexed kol, uint256 idCampaign);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`idKolCampaign`|`uint256`|The unique identifier of the KolCampaign.|
|`kol`|`address`|The address of the KOL (Key Opinion Leader).|
|`idCampaign`|`uint256`|The unique identifier of the Campaign.|

### CampaignContractUpdated
*Emitted when the campaign contract is updated.*


```solidity
event CampaignContractUpdated(address indexed campaignContract);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`campaignContract`|`address`|The address of the updated campaign contract.|

### KolJoined
*Emitted when a KOL joins.*


```solidity
event KolJoined(address indexed kol);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`kol`|`address`|The address of the KOL who joined.|

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

