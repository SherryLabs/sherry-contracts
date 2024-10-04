# IBrand
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/232bf9efe0767602403653d7a237c047730044fe/src/interface/IBrand.sol)

Interface para la gestión de marcas en el contrato.

*Define las funciones necesarias para crear, actualizar, obtener y validar marcas.*


## Functions
### createBrand

Crea una nueva marca.


```solidity
function createBrand(string memory _name, address _brandOwner) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_name`|`string`|Nombre de la marca.|
|`_brandOwner`|`address`|Dirección del propietario de la marca.|


### updateBrand

Actualiza una marca existente.


```solidity
function updateBrand(string memory _name, address _brandOwner, uint256 _idBrand) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_name`|`string`|Nuevo nombre de la marca.|
|`_brandOwner`|`address`|Nueva dirección del propietario de la marca.|
|`_idBrand`|`uint256`|Identificador de la marca a actualizar.|


### getBrand

Obtiene los detalles de una marca.


```solidity
function getBrand(uint256 _idBrand) external view returns (BrandStruct memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idBrand`|`uint256`|Identificador de la marca a obtener.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`BrandStruct`|Estructura BrandStruct con los detalles de la marca.|


### disableBrand

Desactiva una marca.


```solidity
function disableBrand(uint256 _idBrand) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idBrand`|`uint256`|Identificador de la marca a desactivar.|


### enableBrand

Activa una marca.


```solidity
function enableBrand(uint256 _idBrand) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idBrand`|`uint256`|Identificador de la marca a activar.|


### isValidBrand

Verifica si una marca es válida.


```solidity
function isValidBrand(uint256 _idBrand) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idBrand`|`uint256`|Identificador de la marca a verificar.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Booleano que indica si la marca es válida.|


## Structs
### BrandStruct
Estructura que representa una marca.


```solidity
struct BrandStruct {
    uint256 idBrand;
    address brandOwner;
    string name;
    bool active;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`idBrand`|`uint256`|Identificador único de la marca.|
|`brandOwner`|`address`|Dirección del propietario de la marca.|
|`name`|`string`|Nombre de la marca.|
|`active`|`bool`|Estado de la marca (activa o inactiva).|

