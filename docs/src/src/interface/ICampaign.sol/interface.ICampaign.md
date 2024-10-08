# ICampaign
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/7b458adc8d15d374ad0b668358409374cba45ea7/src/interface/ICampaign.sol)

Interface para la gestión de campañas.

*Define las funciones necesarias para crear, actualizar, obtener y validar campañas.*


## Functions
### createCampaign

Crea una nueva campaña.


```solidity
function createCampaign(uint256 _idBrand, string memory _name, uint256 _amount, uint256 _startDate, uint256 _endDate)
    external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idBrand`|`uint256`|Identificador de la marca asociada a la campaña.|
|`_name`|`string`|Nombre de la campaña.|
|`_amount`|`uint256`|Monto objetivo de la campaña.|
|`_startDate`|`uint256`|Fecha de inicio de la campaña (timestamp).|
|`_endDate`|`uint256`|Fecha de finalización de la campaña (timestamp).|


### updateCampaign

Actualiza una campaña existente.


```solidity
function updateCampaign(uint256 _idCampaign, string memory _name, uint256 _amount, uint256 _startDate, uint256 _endDate)
    external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idCampaign`|`uint256`|Identificador de la campaña a actualizar.|
|`_name`|`string`|Nuevo nombre de la campaña.|
|`_amount`|`uint256`|Nuevo monto objetivo de la campaña.|
|`_startDate`|`uint256`|Nueva fecha de inicio de la campaña (timestamp).|
|`_endDate`|`uint256`|Nueva fecha de finalización de la campaña (timestamp).|


### getCampaignById

Obtiene los detalles de una campaña por su identificador.


```solidity
function getCampaignById(uint256 _idCampaign)
    external
    view
    returns (
        uint256 idCampaign,
        uint256 idBrand,
        string memory name,
        uint256 amount,
        bool active,
        uint256 startDate,
        uint256 endDate
    );
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idCampaign`|`uint256`|Identificador de la campaña a obtener.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`idCampaign`|`uint256`|Identificador único de la campaña.|
|`idBrand`|`uint256`|Identificador de la marca asociada a la campaña.|
|`name`|`string`|Nombre de la campaña.|
|`amount`|`uint256`|Monto objetivo de la campaña.|
|`active`|`bool`|Estado de la campaña (activa o inactiva).|
|`startDate`|`uint256`|Fecha de inicio de la campaña (timestamp).|
|`endDate`|`uint256`|Fecha de finalización de la campaña (timestamp).|


### isValidCampaign

Verifica si una campaña es válida.


```solidity
function isValidCampaign(uint256 _idCampaign) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idCampaign`|`uint256`|Identificador de la campaña a verificar.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Booleano que indica si la campaña es válida.|


## Structs
### CampaignStruct
Estructura que representa una campaña.


```solidity
struct CampaignStruct {
    uint256 idCampaign;
    uint256 idBrand;
    string name;
    uint256 amount;
    bool active;
    uint256 startDate;
    uint256 endDate;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`idCampaign`|`uint256`|Identificador único de la campaña.|
|`idBrand`|`uint256`|Identificador de la marca asociada a la campaña.|
|`name`|`string`|Nombre de la campaña.|
|`amount`|`uint256`|Monto objetivo de la campaña.|
|`active`|`bool`|Estado de la campaña (activa o inactiva).|
|`startDate`|`uint256`|Fecha de inicio de la campaña (timestamp).|
|`endDate`|`uint256`|Fecha de finalización de la campaña (timestamp).|

