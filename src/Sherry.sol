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
        address kol;
        uint256 idCampaign;
        string link;
    }

    /*
    struct KOLCampaign {
        address kol;
        uint256 idCampaign;
    }
    */

    mapping(uint256 => Link) public s_links;
    mapping(uint256 => mapping(address => bool)) public s_votesFollowers;

    event Voted(uint256 indexed idLink, address indexed voter);
    event LinkCreated(uint256 idLink, uint256 idKOL, uint256 idCampaign, string link);

    constructor(address _brandContract, address _campaignContract, address _kolContract) Ownable(msg.sender) {
        require(_brandContract != address(0), "Invalid brand contract address");
        require(_campaignContract != address(0), "Invalid campaign contract address");
        require(_kolContract != address(0), "Invalid KOL contract address");
        i_brandContract = IBrand(_brandContract);
        i_campaignContract = ICampaign(_campaignContract);
        i_kolContract = IKOL(_kolContract);
    }

    function createLink(uint256 _idKolCampaign, string memory _link) external {
        (address kol, uint256 idCampaign) = i_kolContract.getKOLCampaign(_idKolCampaign);
        require(idCampaign != 0, "Campaign not found");
        idLink++;
        Link memory link = Link({kol: msg.sender, idCampaign: idCampaign, link: _link});
        s_links[idLink] = link;
    }

    function vote(uint256 _idLink) external returns (bool) {
        require(s_links[_idLink].idCampaign != 0, "Link not found");
        require(!s_votesFollowers[_idLink][msg.sender], "Already voted");
        s_votesFollowers[idLink][msg.sender] = true;
        emit Voted(idLink, msg.sender);
        return true;
    }
}
