//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Campaign} from "./Campaign.sol";

contract KOL is Ownable {
    Campaign public s_campaignContract;
    uint256 public idKolCampaign;

    struct KOLCampaign {
        address kol;
        uint256 idCampaign;
    }

    mapping(address => bool) public s_kols;
    mapping(uint256 => KOLCampaign) public s_kolCampaign;
    mapping(address => KOLCampaign[]) public s_campaignsKol;

    event KolCampaignAdded(uint256 indexed idKolCampaign, address indexed kol, uint256 idCampaign);

    constructor(address _campaignContract) Ownable(msg.sender) {
        require(_campaignContract != address(0), "Invalid campaign contract address");
        s_campaignContract = Campaign(_campaignContract);
    }

    function joinAsKol(address _address) external {
        require(_address != address(0), "Invalid KOL address");
        s_kols[_address] = true;
    }

    function addKolToCampaign(uint256 _idCampaign) external {
        require(s_kols[msg.sender], "Invalid KOL");
        bool isValidCampaign = s_campaignContract.isValidCampaign(_idCampaign);
        require(isValidCampaign, "Invalid campaign");

        KOLCampaign memory kolCampaign = KOLCampaign({kol: msg.sender, idCampaign: _idCampaign});
        idKolCampaign++;
        s_kolCampaign[idKolCampaign] = kolCampaign;
        s_campaignsKol[msg.sender].push(kolCampaign);
        emit KolCampaignAdded(idKolCampaign, msg.sender, _idCampaign);
    }

    function updateCampaignContract(address _campaignContract) external onlyOwner {
        require(_campaignContract != address(0), "Invalid campaign contract address");
        s_campaignContract = Campaign(_campaignContract);
    }

    function getKOLCampaign(uint256 _id) public view returns (address, uint256) {
        require(isValidKolCampaign(_id), "Invalid KOLCampaign");
        KOLCampaign memory kc = s_kolCampaign[_id];
        return (kc.kol, kc.idCampaign);
    }

    function getKolCampaignsByAddress(address _kol) public view returns (KOLCampaign[] memory) {
        require(s_kols[_kol], "Invalid Kol");
        return s_campaignsKol[_kol];
    }

    function isValidKolCampaign(uint256 _id) public view returns (bool) {
        KOLCampaign memory kc = s_kolCampaign[_id];
        return kc.kol != address(0);
    }
}
