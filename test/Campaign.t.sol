// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../src/Campaign.sol";
import "../src/Brand.sol";

contract CampaignTest is Test {
    Campaign campaign;
    Brand brand;
    
    function setUp() public {
        brand = new Brand();
        campaign = new Campaign(address(brand));
    }

    function testCreateCampaign() public {
        brand.createBrand("First Name", address(this));
        (uint256 id, address _brandOwner, string memory name, bool active) = brand.getBrand(1);
        assertEq(id, 1);
        uint256 initialTimestamp = 1000;
        vm.warp(initialTimestamp);
        uint256 startDate = block.timestamp - 100;
        uint256 endDate = block.timestamp + 1 days;
        
        //campaign.createCampaign(1, "First Campaign", 100, startDate, endDate);
    }
}
