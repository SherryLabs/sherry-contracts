//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/// @title IBrand Interface
/// @notice Interface para la gestión de marcas.
/// @dev Define las funciones necesarias para crear y actualizar marcas.
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

    /**
     * @dev Emitted when a new brand is created.
     * @param idBrand The unique identifier of the brand.
     * @param brandOwner The address of the owner of the brand.
     * @param name The name of the brand.
     */
    event BrandCreated(uint256 indexed idBrand, address indexed brandOwner, string name);

    /**
     * @dev Emitted when an existing brand is updated.
     * @param idBrand The unique identifier of the brand.
     * @param brandOwner The address of the owner of the brand.
     * @param name The updated name of the brand.
     */
    event BrandUpdated(uint256 indexed idBrand, address indexed brandOwner, string name);

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
    /// @return idBrand Identificador único de la marca.
    /// @return brandOwner Dirección del propietario de la marca.
    /// @return name Nombre de la marca.
    /// @return active Estado de la marca (activa o inactiva).
    function getBrand(uint256 _idBrand)
        external
        view
        returns (uint256 idBrand, address brandOwner, string memory name, bool active);

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
