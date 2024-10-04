pragma solidity ^0.8.25;

interface ICampaign {
    function createCampaign(
        uint256 _idBrand,
        string memory _name,
        uint256 _amount,
        uint256 _startDate,
        uint256 _endDate
    ) external;

    function updateCampaign(
        uint256 _idCampaign,
        string memory _name,
        uint256 _amount,
        uint256 _startDate,
        uint256 _endDate
    ) external;
}
