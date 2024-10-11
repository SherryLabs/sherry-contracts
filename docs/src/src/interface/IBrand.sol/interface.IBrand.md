# IBrand
[Git Source](https://github.com/SherryLabs/sherry-contracts/blob/250890a0c8afb7b7382121b0d8e526c798b0670c/src/interface/IBrand.sol)

Interface para la gestión de marcas.

*Define las funciones necesarias para crear y actualizar marcas.*


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
function getBrand(uint256 _idBrand)
    external
    view
    returns (uint256 idBrand, address brandOwner, string memory name, bool active);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_idBrand`|`uint256`|Identificador de la marca a obtener.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`idBrand`|`uint256`|Identificador único de la marca.|
|`brandOwner`|`address`|Dirección del propietario de la marca.|
|`name`|`string`|Nombre de la marca.|
|`active`|`bool`|Estado de la marca (activa o inactiva).|


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


## Events
### BrandCreated
*Emitted when a new brand is created.*


```solidity
event BrandCreated(uint256 indexed idBrand, address indexed brandOwner, string name);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`idBrand`|`uint256`|The unique identifier of the brand.|
|`brandOwner`|`address`|The address of the owner of the brand.|
|`name`|`string`|The name of the brand.|

### BrandUpdated
*Emitted when an existing brand is updated.*


```solidity
event BrandUpdated(uint256 indexed idBrand, address indexed brandOwner, string name);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`idBrand`|`uint256`|The unique identifier of the brand.|
|`brandOwner`|`address`|The address of the owner of the brand.|
|`name`|`string`|The updated name of the brand.|

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

