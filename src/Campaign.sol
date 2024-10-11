//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IBrand} from "./interface/IBrand.sol";

contract Campaign is Ownable {
    IBrand public s_brandContract;
    uint256 public idCampaign;

    struct CampaignStruct {
        uint256 idCampaign;
        uint256 idBrand;
        string name;
        uint256 amount;
        bool active;
        uint256 startDate;
        uint256 endDate;
    }

    mapping(uint256 => CampaignStruct) public s_campaigns;
    mapping(uint256 => string) public s_uriCampaign;

    event CampaignCreated(
        uint256 indexed idCampaign,
        uint256 indexed idBrand,
        string name,
        uint256 amount,
        uint256 startDate,
        uint256 endDate,
        string uri
    );
    event CampaignUpdated(uint256 indexed idCampaign, string name, uint256 amount);

    constructor(address _brandContract) Ownable(msg.sender) {
        require(_brandContract != address(0), "Invalid brand contract address");
        s_brandContract = IBrand(_brandContract);
    }

    function createCampaign(
        uint256 _idBrand,
        string memory _name,
        uint256 _amount,
        uint256 _startDate,
        uint256 _endDate,
        string memory _uri
    ) external onlyOwner {
        require(s_brandContract.isValidBrand(_idBrand), "Invalid brand");
        require(bytes(_name).length > 0, "Invalid campaign name");
        require(_endDate > _startDate, "Invalid dates");
        idCampaign++;
        CampaignStruct memory campaign = CampaignStruct({
            idCampaign: idCampaign,
            idBrand: _idBrand,
            name: _name,
            amount: _amount,
            active: true,
            startDate: _startDate,
            endDate: _endDate
        });
        s_campaigns[idCampaign] = campaign;
        emit CampaignCreated(idCampaign, _idBrand, _name, _amount, _startDate, _endDate, _uri);
    }

    function updateCampaign(
        uint256 _idCampaign,
        string memory _name,
        uint256 _amount,
        uint256 _startDate,
        uint256 _endDate
    ) external {
        CampaignStruct storage campaign = s_campaigns[_idCampaign];
        require(campaign.idCampaign != 0, "Campaign not found");
        require(bytes(_name).length > 0, "Invalid campaign name");
        require(_endDate > _startDate, "Invalid dates");
        campaign.name = _name;
        campaign.amount = _amount;
        campaign.startDate = _startDate;
        campaign.endDate = _endDate;
        emit CampaignUpdated(_idCampaign, _name, _amount);
    }

    function getCampaignById(uint256 _idCampaign)
        external
        view
        returns (uint256, uint256, string memory, uint256, bool, uint256, uint256)
    {
        require(isValidCampaign(_idCampaign), "Campaign ID invalid");
        CampaignStruct memory c = s_campaigns[_idCampaign];
        return (c.idCampaign, c.idBrand, c.name, c.amount, c.active, c.startDate, c.endDate);
    }

    function isValidCampaign(uint256 _idCampaign) public view returns (bool) {
        CampaignStruct memory c = s_campaigns[_idCampaign];
        require(c.idCampaign != 0, "Invalid Campaign");
        require(c.active, "Campaign inactive");
        require(block.timestamp <= c.endDate, "Campaign has ended");
        return true;
    }

    function getUriCampaign(uint256 _idCampaign) public view returns (string memory) {
        require(isValidCampaign(_idCampaign), "Invalid campaign");
        return s_uriCampaign[_idCampaign];
    }
}
