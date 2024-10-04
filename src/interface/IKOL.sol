pragma solidity ^0.8.25;

interface IKOL {
    function createKOL(string memory _name, address _kolOwner) external;

    function updateKOL(string memory _name, address _kolOwner, uint256 _idKOL) external;

    function disableKOL(uint256 _idKOL) external;

    function getKOLCampaign(uint256 _id) external returns (address,uint256);

    function enableKOL(uint256 _idKOL) external;

    function isValidKolCampaign(uint _id) external returns(bool isValid);
}
