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

    function setUp() public {
        brand = new Brand();
        campaign = new Campaign(address(brand));
        kol = new KOL(address(campaign));
        sherry = new Sherry(address(brand), address(campaign), address(kol));
    }

    function testCreateLink() external {
        uint256 idKolCampaign = 1;
        address kolAddress = address(1337);
        string memory url = "https://";
        brand.createBrand("First Brand", msg.sender);
        uint256 startDate = block.timestamp;
        uint256 endDate = block.timestamp + 1 days;
        campaign.createCampaign(1, "Nike", 100, startDate, endDate);
        kol.addKol(kolAddress);
        // Se setea el KOL como el caller
        vm.startPrank(kolAddress);
        // El KOL se puede agregar a si mismo a la campaña
        kol.addKolToCampaign(1);
        // El KOL solo puede crear links para el mismo
        sherry.createLink(idKolCampaign, url);
        vm.stopPrank();
    }

    function testVote() external {
        uint256 idKolCampaign = 1;
        address kolAddress = address(1337);
        string memory url = "https://";
        brand.createBrand("First Brand", msg.sender);
        uint256 startDate = block.timestamp;
        uint256 endDate = block.timestamp + 1 days;
        campaign.createCampaign(1, "Nike", 100, startDate, endDate);
        kol.addKol(kolAddress);
        // Se setea el KOL como el caller
        vm.startPrank(kolAddress);
        // El KOL se puede agregar a si mismo a la campaña
        kol.addKolToCampaign(1);
        // El KOL solo puede crear links para el mismo
        sherry.createLink(idKolCampaign, url);
        vm.stopPrank();
        sherry.vote(1);
        console.log(sherry.s_votes(1));
    }
    
}
