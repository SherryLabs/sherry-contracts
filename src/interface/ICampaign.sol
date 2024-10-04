pragma solidity ^0.8.25;

/// @title ICampaign Interface
/// @notice Interface para la gestión de campañas.
/// @dev Define las funciones necesarias para crear y actualizar campañas.
interface ICampaign {
    /// @notice Crea una nueva campaña.
    /// @param _idBrand Identificador de la marca asociada a la campaña.
    /// @param _name Nombre de la campaña.
    /// @param _amount Monto objetivo de la campaña.
    /// @param _startDate Fecha de inicio de la campaña (timestamp).
    /// @param _endDate Fecha de finalización de la campaña (timestamp).
    function createCampaign(
        uint256 _idBrand,
        string memory _name,
        uint256 _amount,
        uint256 _startDate,
        uint256 _endDate
    ) external;

    /// @notice Actualiza una campaña existente.
    /// @param _idCampaign Identificador de la campaña a actualizar.
    /// @param _name Nuevo nombre de la campaña.
    /// @param _amount Nuevo monto objetivo de la campaña.
    /// @param _startDate Nueva fecha de inicio de la campaña (timestamp).
    /// @param _endDate Nueva fecha de finalización de la campaña (timestamp).
    function updateCampaign(
        uint256 _idCampaign,
        string memory _name,
        uint256 _amount,
        uint256 _startDate,
        uint256 _endDate
    ) external;
}