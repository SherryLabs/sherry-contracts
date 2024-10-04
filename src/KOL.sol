//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Campaign} from "./Campaign.sol";
contract KOL is Ownable {
    Campaign public s_campaignContract;

    uint256 public idLink;
    uint256 public idKOLCampaign;

    struct KOLCampaign {
        address kol;
        uint256 idCampaign;
    }

    struct Link {
        address kol;
        uint256 idCampaign;
        string link;
    }

    mapping(address => bool) public s_kols;
    mapping(uint256 => Link) public s_links;
    mapping(uint256 => mapping(address => KOLCampaign)) public s_kolCampaigns;
    mapping(uint256 => mapping(address => bool)) public s_votesFollowers;

    event Voted(uint256 indexed idLink, address indexed voter);
    event LinkCreated(
        uint256 idLink,
        uint256 idKOL,
        uint256 idCampaign,
        string link
    );

    constructor(address _campaignContract) Ownable(msg.sender) {
        require(
            _campaignContract != address(0),
            "Invalid campaign contract address"
        );
        s_campaignContract = Campaign(_campaignContract);
    }

    function addKol(address _address) external onlyOwner {
        require(_address != address(0), "Invalid KOL address");
        s_kols[_address] = true;
    }

    function addKolToCampaign(
        //address _addressKol,
        uint256 _idCampaign
    ) external onlyOwner() {
        require(s_kols[msg.sender], "Invalid KOL");
        bool isValidCampaign = s_campaignContract.isValidCampaign(_idCampaign);
        require(isValidCampaign, "Invalid campaign");

        KOLCampaign memory kolCampaign = KOLCampaign({
            kol: msg.sender,
            idCampaign: _idCampaign
        });
        idKOLCampaign++;
        s_kolCampaigns[idKOLCampaign][msg.sender] = kolCampaign;
    }

    function createLink(uint256 _idKolCampaign, string memory _link) external {
        KOLCampaign memory _kolCampaign = s_kolCampaigns[_idKolCampaign][msg.sender];
        require(_kolCampaign.idCampaign != 0, "Campaign not found");

        idLink++;
        Link memory link = Link({
            kol: msg.sender,
            idCampaign: _kolCampaign.idCampaign,
            link: _link
        });
        s_links[idLink] = link;
    }

    function vote(uint256 _idLink) external returns(bool){
        require(s_links[_idLink].idCampaign != 0, "Link not found");
        require(!s_votesFollowers[_idLink][msg.sender], "Already voted");
        s_votesFollowers[idLink][msg.sender] = true;
        emit Voted(idLink, msg.sender);
        return true;
    }

    function updateCampaignContract(
        address _campaignContract
    ) external onlyOwner {
        require(
            _campaignContract != address(0),
            "Invalid campaign contract address"
        );
        s_campaignContract = Campaign(_campaignContract);
    }
}
