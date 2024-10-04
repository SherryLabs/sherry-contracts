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
}
