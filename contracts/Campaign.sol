//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Brand} from "./Brand.sol";

contract Campaign is Ownable {
    Brand public brandContract;
    uint256 public idCampaign;

    struct Campaign {
        uint256 idCampaign;
        uint256 idBrand;
        string name;
        uint256 amount;
        bool active;
        uint256 startDate;
        uint256 endDate;
    }

    mapping(uint256 => Campaign) public campaigns;

    constructor(address _brandContract) Ownable(msg.sender) {
        require(_brandContract != address(0), "Invalid brand contract address");
        brandContract = Brand(_brandContract);
    }

    function createCampaign(
        uint256 _idBrand, 
        string memory _name, 
        uint256 _amount, 
        uint256 _startDate, 
        uint256 _endDate) 
    external {
        require(brandContract.isValidBrand(_idBrand), "Invalid brand");
        require(bytes(_name).length > 0, "Invalid campaign name");
        require(_endDate > _startDate, "Invalid dates");
        idCampaign++;
        Campaign memory campaign = Campaign({
            idCampaign: idCampaign,
            idBrand: _idBrand,
            name: _name,
            amount: _amount,
            active: true,
            startDate: _startDate,
            endDate: _endDate
        });
        campaigns[idCampaign] = campaign;
    }

    function updateCampaign(
        uint256 _idCampaign, 
        string memory _name, 
        uint256 _amount, 
        uint256 _startDate, 
        uint256 _endDate)
    external { 
        Campaign storage campaign = campaigns[_idCampaign];
        require(campaign.idCampaign != 0, "Campaign not found");
        require(bytes(_name).length > 0, "Invalid campaign name");
        require(_endDate > _startDate, "Invalid dates");
        campaign.name = _name;
        campaign.amount = _amount;
        campaign.startDate = _startDate;
        campaign.endDate = _endDate;
    }

    function isValidCampaign(uint256 _idCampaign) external view returns (bool) {
        return campaigns[_idCampaign].idCampaign != 0;
    }
}