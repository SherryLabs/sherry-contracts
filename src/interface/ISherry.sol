pragma solidity ^0.8.25;

/// @title ISherry Interface
/// @notice Interface para la gestión de enlaces y votaciones.
/// @dev Define las funciones y eventos necesarios para crear enlaces y votar en ellos.
interface ISherry {
    /// @notice Evento emitido cuando un usuario vota en un enlace.
    /// @param idLink Identificador del enlace votado.
    /// @param voter Dirección del usuario que votó.
    event Voted(uint256 indexed idLink, address indexed voter);

    /// @notice Evento emitido cuando se crea un nuevo enlace.
    /// @param idLink Identificador del nuevo enlace.
    /// @param kol Dirección del KOL asociado al enlace.
    /// @param idCampaign Identificador de la campaña asociada al enlace.
    /// @param url URL del enlace creado.
    event LinkCreated(uint256 indexed idLink, address indexed kol, uint256 indexed idCampaign, string url);

    /// @notice Crea un nuevo enlace asociado a una campaña de KOL.
    /// @param _idKolCampaign Identificador de la campaña de KOL.
    /// @param _url URL del enlace a crear.
    function createLink(uint256 _idKolCampaign, string memory _url) external;

    /// @notice Permite a un usuario votar en un enlace.
    /// @param _idLink Identificador del enlace a votar.
    /// @return Booleano que indica si el voto fue exitoso.
    function vote(uint256 _idLink) external returns (bool);
}
