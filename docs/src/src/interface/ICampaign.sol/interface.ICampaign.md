# ICampaign
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/2fd4840f6f8521f3419b23a60a2607a11251a45b/src/interface/ICampaign.sol)

Interface para la gestión de campañas.

*Define las funciones necesarias para crear y actualizar campañas.*


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


