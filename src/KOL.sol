//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Campaign} from "./Campaign.sol";

contract KOL is Ownable {
    Campaign public s_campaignContract;
    uint256 public idKOLCampaign;

    struct KOLCampaign {
        address kol;
        uint256 idCampaign;
    }

    mapping(address => bool) public s_kols;
    mapping(uint256 => KOLCampaign) public s_kolCampaign;
    
    constructor(address _campaignContract) Ownable(msg.sender) {
        require(_campaignContract != address(0), "Invalid campaign contract address");
        s_campaignContract = Campaign(_campaignContract);
    }

    function addKol(address _address) external onlyOwner {
        require(_address != address(0), "Invalid KOL address");
        s_kols[_address] = true;
    }

    function addKolToCampaign(uint256 _idCampaign) external  {
        require(s_kols[msg.sender], "Invalid KOL");
        bool isValidCampaign = s_campaignContract.isValidCampaign(_idCampaign);
        require(isValidCampaign, "Invalid campaign");

        KOLCampaign memory kolCampaign = KOLCampaign({kol: msg.sender, idCampaign: _idCampaign});
        idKOLCampaign++;
        s_kolCampaign[idKOLCampaign] = kolCampaign;
    }

    function updateCampaignContract(address _campaignContract) external onlyOwner {
        require(_campaignContract != address(0), "Invalid campaign contract address");
        s_campaignContract = Campaign(_campaignContract);
    }

    function getKOLCampaign(uint256 _id) public returns (address, uint256) {
        KOLCampaign memory kc = s_kolCampaigns[_id];
        return (kc.idCampaign, kc.kol);
    }

    function isValidKolCampaign(uint256 _id) public returns (bool) {
        KOLCampaign memory kc = s_kolCampaigns[_id];
    }
}
