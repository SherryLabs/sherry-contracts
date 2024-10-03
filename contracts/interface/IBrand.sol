pragma solidity ^0.8.25;

/// @title IBrand Interface
/// @notice Interface para la gestión de marcas en el contrato.
/// @dev Define las funciones necesarias para crear, actualizar, obtener y validar marcas.
interface IBrand {
    /// @notice Estructura que representa una marca.
    /// @param idBrand Identificador único de la marca.
    /// @param brandOwner Dirección del propietario de la marca.
    /// @param name Nombre de la marca.
    /// @param active Estado de la marca (activa o inactiva).
    struct BrandStruct {
        uint256 idBrand;
        address brandOwner;
        string name;
        bool active;
    }

    /// @notice Crea una nueva marca.
    /// @param _name Nombre de la marca.
    /// @param _brandOwner Dirección del propietario de la marca.
    function createBrand(string memory _name, address _brandOwner) external;

    /// @notice Actualiza una marca existente.
    /// @param _name Nuevo nombre de la marca.
    /// @param _brandOwner Nueva dirección del propietario de la marca.
    /// @param _idBrand Identificador de la marca a actualizar.
    function updateBrand(string memory _name, address _brandOwner, uint256 _idBrand) external;

    /// @notice Obtiene los detalles de una marca.
    /// @param _idBrand Identificador de la marca a obtener.
    /// @return Estructura BrandStruct con los detalles de la marca.
    function getBrand(uint256 _idBrand) external view returns (BrandStruct memory);

    /// @notice Desactiva una marca.
    /// @param _idBrand Identificador de la marca a desactivar.
    function disableBrand(uint256 _idBrand) external;

    /// @notice Activa una marca.
    /// @param _idBrand Identificador de la marca a activar.
    function enableBrand(uint256 _idBrand) external;

    /// @notice Verifica si una marca es válida.
    /// @param _idBrand Identificador de la marca a verificar.
    /// @return Booleano que indica si la marca es válida.
    function isValidBrand(uint256 _idBrand) external view returns (bool);
}