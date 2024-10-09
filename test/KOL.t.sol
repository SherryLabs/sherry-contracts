pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../src/KOL.sol";
import "../src/Brand.sol";
import "../src/Campaign.sol";

contract KOLTest is Test {
    Brand brand;
    Campaign campaign;
    KOL kol;

    function setUp() public {
        brand = new Brand();
        campaign = new Campaign(address(brand));
        kol = new KOL(address(campaign));
    }

    function testJoinAsKol() public {
        address kolAddress = address(1337);
        kol.joinAsKol(kolAddress);
        assertEq(kol.s_kols(kolAddress), true);
    }

    function testAddKolToCampaign() public {
        brand.createBrand("First Name", address(this));
        address kolAddress = address(1337);
        vm.warp(0);
        uint256 startDate = block.timestamp;
        uint256 endDate = block.timestamp + 1 days;
        campaign.createCampaign(1, "First Campaign", 100, startDate, endDate);
        kol.joinAsKol(kolAddress);
        uint256 idCampaign = campaign.idCampaign();
        vm.prank(kolAddress);
        kol.addKolToCampaign(idCampaign, kolAddress);
    }
}
