//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/// @title IKOL Interface
/// @notice Interface para la gestión de KOLs y sus campañas.
/// @dev Define las funciones necesarias para agregar KOLs y asignarlos a campañas.
interface IKOL {
    /// @notice Estructura que representa una campaña de KOL.
    /// @param kol Dirección del KOL.
    /// @param idCampaign Identificador de la campaña.
    struct KOLCampaign {
        address kol;
        uint256 idCampaign;
    }

    /**
     * @dev Emitted when a new KolCampaign is added.
     * @param idKolCampaign The unique identifier of the KolCampaign.
     * @param kol The address of the KOL (Key Opinion Leader).
     * @param idCampaign The unique identifier of the Campaign.
     */
    event KolCampaignAdded(uint256 indexed idKolCampaign, address indexed kol, uint256 idCampaign);
    /**
     * @dev Emitted when the campaign contract is updated.
     * @param campaignContract The address of the updated campaign contract.
     */
    event CampaignContractUpdated(address indexed campaignContract);

    /**
     * @dev Emitted when a KOL joins.
     * @param kol The address of the KOL who joined.
     */
    event KolJoined(address indexed kol);

    /// @notice Agrega un nuevo KOL.
    /// @param _address Dirección del KOL.
    function joinAsKol(address _address) external;

    /// @notice Asigna un KOL a una campaña.
    /// @param _idCampaign Identificador de la campaña.
    function addKolToCampaign(uint256 _idCampaign) external;

    /// @notice Verifica si una dirección es un KOL válido.
    /// @param _address Dirección a verificar.
    /// @return Booleano que indica si la dirección es un KOL válido.
    function isKol(address _address) external view returns (bool);

    /// @notice Obtiene las campañas asociadas a un KOL.
    /// @param _kol Dirección del KOL.
    /// @return Array de estructuras KOLCampaign asociadas al KOL.
    function getCampaignsByKol(address _kol) external view returns (KOLCampaign[] memory);

    // @notice Obtiene Info KOL Campaign asociada al Id Kol Campaign
    // @param _id Id KolCampaign
    // @return Address del Kol y el ID de la Campaña.
    function getKOLCampaign(uint256 _id) external view returns (address, uint256);
}
