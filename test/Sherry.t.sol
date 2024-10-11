// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import {Sherry} from "../src/Sherry.sol";
import "../src/Brand.sol";
import "../src/KOL.sol";
import "../src/Campaign.sol";

contract SherryTest is Test {
    Sherry sherry;
    Brand brand;
    Campaign campaign;
    KOL kol;

    string public uri = "https://";

    function setUp() public {
        brand = new Brand();
        campaign = new Campaign(address(brand));
        kol = new KOL(address(campaign));
        sherry = new Sherry(address(brand), address(campaign), address(kol));
    }

    function testCreatePost() external {
        uint256 idKolCampaign = 1;
        address kolAddress = address(1337);
        string memory url = "https://";
        brand.createBrand("First Brand", msg.sender);
        uint256 startDate = block.timestamp;
        uint256 endDate = block.timestamp + 1 days;
        campaign.createCampaign(1, "Nike", 100, startDate, endDate, uri);
        kol.joinAsKol(kolAddress);
        // Se setea el KOL como el caller
        vm.startPrank(kolAddress);
        // El KOL se puede agregar a si mismo a la campaña
        kol.addKolToCampaign(1, kolAddress);
        // El KOL solo puede crear links para el mismo
        sherry.createPost(idKolCampaign, url);
        vm.stopPrank();
    }

    function testVote() external {
        uint256 idKolCampaign = 1;
        address voter1 = address(1337);
        address voter2 = address(1338);

        string memory url = "https://";
        brand.createBrand("First Brand", msg.sender);
        uint256 startDate = block.timestamp;
        uint256 endDate = block.timestamp + 1 days;
        campaign.createCampaign(1, "Nike", 100, startDate, endDate, uri);
        campaign.createCampaign(1, "Adidas", 1000, startDate, endDate, uri);
        // Se setea el KOL como el caller
        vm.startPrank(voter1);
        // El KOL se puede agregar a si mismo a la campaña
        kol.addKolToCampaign(1, voter1);
        kol.addKolToCampaign(2, voter2);
        // El KOL solo puede crear posts para el mismo
        sherry.createPost(1, url);
        sherry.createPost(2, url);
        vm.stopPrank();
        sherry.vote(1, voter1);
        sherry.vote(2, voter2);
        sherry.vote(1, voter1);
        console.log(sherry.s_votes(1));
    }
}
