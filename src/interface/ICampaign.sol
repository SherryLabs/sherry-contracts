pragma solidity ^0.8.25;

/// @title ICampaign Interface
/// @notice Interface para la gestión de campañas.
/// @dev Define las funciones necesarias para crear, actualizar, obtener y validar campañas.
interface ICampaign {
    /// @notice Estructura que representa una campaña.
    /// @param idCampaign Identificador único de la campaña.
    /// @param idBrand Identificador de la marca asociada a la campaña.
    /// @param name Nombre de la campaña.
    /// @param amount Monto objetivo de la campaña.
    /// @param active Estado de la campaña (activa o inactiva).
    /// @param startDate Fecha de inicio de la campaña (timestamp).
    /// @param endDate Fecha de finalización de la campaña (timestamp).
    struct CampaignStruct {
        uint256 idCampaign;
        uint256 idBrand;
        string name;
        uint256 amount;
        bool active;
        uint256 startDate;
        uint256 endDate;
    }

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

    /// @notice Obtiene los detalles de una campaña por su identificador.
    /// @param _idCampaign Identificador de la campaña a obtener.
    /// @return idCampaign Identificador único de la campaña.
    /// @return idBrand Identificador de la marca asociada a la campaña.
    /// @return name Nombre de la campaña.
    /// @return amount Monto objetivo de la campaña.
    /// @return active Estado de la campaña (activa o inactiva).
    /// @return startDate Fecha de inicio de la campaña (timestamp).
    /// @return endDate Fecha de finalización de la campaña (timestamp).
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

    /// @notice Verifica si una campaña es válida.
    /// @param _idCampaign Identificador de la campaña a verificar.
    /// @return Booleano que indica si la campaña es válida.
    function isValidCampaign(uint256 _idCampaign) external view returns (bool);
}
