// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../src/Campaign.sol";
import "../src/Brand.sol";

contract CampaignTest is Test {
    Campaign campaign;
    Brand brand;

    string public uri = "https://";

    function setUp() public {
        brand = new Brand();
        campaign = new Campaign(address(brand));
    }

    function testCreateCampaign() public {
        brand.createBrand("First Name", address(this));
        (uint256 id,,,) = brand.getBrand(1);
        assertEq(id, 1);
        vm.warp(0);
        uint256 startDate = block.timestamp;
        uint256 endDate = block.timestamp + 1 days;
        campaign.createCampaign(1, "First Campaign", 100, startDate, endDate, uri);
        uint256 idCampaign = campaign.idCampaign();
        assertEq(idCampaign, 1);
    }

    function testCreateCampaignInvalidBrand() external {
        uint256 startDate = block.timestamp;
        uint256 endDate = block.timestamp + 1 days;
        vm.expectRevert("Invalid brand");
        campaign.createCampaign(1, "First Campaign", 100, startDate, endDate, uri);
        brand.createBrand("First Name", address(this));
        vm.expectRevert("Invalid campaign name");
        campaign.createCampaign(1, "", 100, startDate, endDate, uri);
        vm.expectRevert("Invalid dates");
        campaign.createCampaign(1, "First Campaign", 100, endDate, startDate, uri);
        campaign.createCampaign(1, "First Campaign", 100, startDate, endDate, uri);
        assertEq(campaign.idCampaign(), 1);
    }
}
