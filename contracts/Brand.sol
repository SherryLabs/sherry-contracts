//SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract Brand is Ownable {
    uint256 public idBrand;

    struct Brand {
        uint256 idBrand;
        address brandOwner;
        string name;
        bool active;
    }

    mapping(uint256 => Brand) public brands;

    constructor() Ownable(msg.sender) {}

    function createBrand(string memory _name, address _brandOwner) onlyOwner external {
        require(bytes(_name).length > 0, "Invalid brand name");
        require(_brandOwner != address(0), "Invalid brand owner address");
        idBrand++;
        Brand memory brand = Brand({
            idBrand: idBrand,
            brandOwner: _brandOwner,
            name: _name,
            active: true
        });

        brands[idBrand] = brand;
    }

    function updateBrand(string memory _name, address _brandOwner, uint256 _idBrand) onlyOwner external {
        require(bytes(_name).length > 0, "Invalid brand name");
        require(_brandOwner != address(0), "Invalid brand owner address");
        Brand storage brand = brands[_idBrand];
        brand.name = _name;
        brand.brandOwner = _brandOwner;
    }

    function disableBrand(uint256 _idBrand) onlyOwner external {
        Brand storage brand = brands[_idBrand];
        brand.active = false;
    }

    function enableBrand(uint256 _idBrand) onlyOwner external {
        Brand storage brand = brands[_idBrand];
        brand.active = true;
    }

    function getBrand(uint256 _idBrand) external view returns (Brand memory) {
        return brands[_idBrand];
    }

    function isValidBrand(uint256 _idBrand) external view returns (bool) {
        address addressOwner = brands[_idBrand].brandOwner;
        return addressOwner != address(0);
    }

}
