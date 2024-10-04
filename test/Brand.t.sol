// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../contracts/Brand.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract BrandTest is Test {
    Brand brand;
    address owner = address(this);
    address brandOwner = address(0x123);

    function setUp() public {
        brand = new Brand();
    }

    function testCreateBrand() public {
        brand.createBrand("TestBrand", brandOwner);
        (uint256 id, address _brandOwner, string memory name, bool active) = brand.getBrand(1);
        assertEq(id, 1);
        assertEq(_brandOwner, brandOwner);
        assertEq(name, "TestBrand");
        assertTrue(active);
    }

    function testUpdateBrand() public {
        brand.createBrand("TestBrand", brandOwner);
        brand.updateBrand("UpdatedBrand", brandOwner, 1);
        (,, string memory name,) = brand.getBrand(1);
        assertEq(name, "UpdatedBrand");
    }

    function testDisableBrand() public {
        brand.createBrand("TestBrand", brandOwner);
        brand.disableBrand(1);
        (,,, bool active) = brand.getBrand(1);
        assertFalse(active);
    }

    function testEnableBrand() public {
        brand.createBrand("TestBrand", brandOwner);
        brand.disableBrand(1);
        brand.enableBrand(1);
        (,,, bool active) = brand.getBrand(1);
        assertTrue(active);
    }

    function testIsValidBrand() public {
        brand.createBrand("TestBrand", brandOwner);
        bool isValid = brand.isValidBrand(1);
        assertTrue(isValid);
    }

    function testFailCreateBrandWithEmptyName() public {
        brand.createBrand("", brandOwner);
    }

    function testFailCreateBrandWithZeroAddress() public {
        brand.createBrand("TestBrand", address(0));
    }

    function testFailUpdateBrandUnauthorized() public {
        brand.createBrand("TestBrand", brandOwner);
        brand.updateBrand("UpdatedBrand", brandOwner, 1);
    }
}
