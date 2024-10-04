// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {IBrand} from "./interface/IBrand.sol";
import {ICampaign} from "./interface/ICampaign.sol";
import {IKOL} from "./interface/IKOL.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Sherry is Ownable {
    IBrand public i_brandContract;
    ICampaign public i_campaignContract;
    IKOL public i_kolContract;

    uint256 public idLink;

    struct Link {
        uint256 idKolCampaign;
        address kol;
        uint256 idCampaign;
        string url;
    }

    mapping(uint256 => Link) public s_links;
    mapping(uint256 => mapping(address => bool)) public s_votesFollowers;

    event Voted(uint256 indexed idLink, address indexed voter);
    event LinkCreated(uint256 indexed idLink, address indexed kol, uint256 indexed idCampaign, string url);

    constructor(address _brandContract, address _campaignContract, address _kolContract) Ownable(msg.sender) {
        require(_brandContract != address(0), "Invalid brand contract address");
        require(_campaignContract != address(0), "Invalid campaign contract address");
        require(_kolContract != address(0), "Invalid KOL contract address");
        i_brandContract = IBrand(_brandContract);
        i_campaignContract = ICampaign(_campaignContract);
        i_kolContract = IKOL(_kolContract);
    }

    function createLink(uint256 _idKolCampaign, string memory _url) external {
        (address kol, uint256 idCampaign) = i_kolContract.getKOLCampaign(_idKolCampaign);
        require(kol == msg.sender, "You can only create links for yourself");
        require(idCampaign != 0, "Campaign not found");
        idLink++;
        Link memory link = Link({idKolCampaign: _idKolCampaign, kol: kol, idCampaign: idCampaign, url: _url});
        s_links[idLink] = link;
        emit LinkCreated(idLink, kol, idCampaign, _url);
    }

    function vote(uint256 _idLink) external returns (bool) {
        require(s_links[_idLink].idCampaign != 0, "Link not found");
        require(!s_votesFollowers[_idLink][msg.sender], "Already voted");
        s_votesFollowers[idLink][msg.sender] = true;
        emit Voted(idLink, msg.sender);
        return true;
    }
}
