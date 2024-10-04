pragma solidity ^0.8.25;

interface IKOL {
    function createKOL(
        string memory _name,
        address _kolOwner
    ) external;

    function updateKOL(
        string memory _name,
        address _kolOwner,
        uint256 _idKOL
    ) external;

    function disableKOL(uint256 _idKOL) external;

    function enableKOL(uint256 _idKOL) external;
}