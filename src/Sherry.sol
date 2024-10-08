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

    uint256 public idPost;

    struct Post {
        uint256 idKolCampaign;
        address kol;
        uint256 idCampaign;
        string url;
    }

    Post[] posts = Post[];

    mapping(uint256 => Post) public s_posts;
    mapping(uint256 => mapping(address => bool)) public s_votesFollowers;
    mapping(uint256 => uint256) public s_votes;
    mapping(uint256 => mapping(address => bool)) public s_votesByCampaign;

    event Voted(uint256 indexed idPost, address indexed voter);
    event postCreated(uint256 indexed idPost, address indexed kol, uint256 indexed idCampaign, string url);

    constructor(address _brandContract, address _campaignContract, address _kolContract) Ownable(msg.sender) {
        require(_brandContract != address(0), "Invalid brand contract address");
        require(_campaignContract != address(0), "Invalid campaign contract address");
        require(_kolContract != address(0), "Invalid KOL contract address");
        i_brandContract = IBrand(_brandContract);
        i_campaignContract = ICampaign(_campaignContract);
        i_kolContract = IKOL(_kolContract);
    }

    function createPost(uint256 _idKolCampaign, string memory _url) external {
        (address kol, uint256 idCampaign) = i_kolContract.getKOLCampaign(_idKolCampaign);
        require(kol == msg.sender, "You can only create posts for yourself");
        require(idCampaign != 0, "Campaign not found");
        idPost++;
        Post memory post = Post({idKolCampaign: _idKolCampaign, kol: kol, idCampaign: idCampaign, url: _url});
        s_posts[idPost] = post;
        emit postCreated(idPost, kol, idCampaign, _url);
    }

    function vote(uint256 _idPost) external returns (bool) {
        require(s_posts[_idPost].idCampaign != 0, "post not found");
        uint256 idCampaign = s_posts[_idPost].idCampaign;
        require(!s_votesByCampaign[idCampaign][msg.sender], "Already voted for this campaign");
        s_votesByCampaign[idCampaign][msg.sender] = true;
        s_votesFollowers[idPost][msg.sender] = true;
        s_votes[_idPost]++;
        emit Voted(idPost, msg.sender);
        return true;
    }

    function getUri(uint256 _idPost) public view returns (string memory) {
        require(s_posts[_idPost].idCampaign != 0, "post not found");
        return s_posts[_idPost].url;
    }
}
