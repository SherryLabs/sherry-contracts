//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SherryBackup is Ownable(msg.sender) {
/*
    uint256 public idBrand;
    IERC20 public usdcToken;

    struct Brand {
        uint256 idBrand;
        string name;
        uint256 amount;
        bool active;
    }

    //@dev user address => amount
    mapping(address => uint256) public amounts;
    //@dev brand id => total amount (Amounts deposited by Brand to be distributed)
    mapping(uint256 => uint256) public brandAmounts;
    //@dev brand id => brand details
    mapping(uint256 => Brand) public brands;
    //@dev creator id => brand id - Save creators linked to a brand
    mapping(uint256 => uint256) public creatorBrand;


    constructor(address _usdcToken) Ownable(msg.sender){
        require(_usdcToken != address(0), "Invalid USDC token address");
        usdcToken = IERC20(_usdcToken);
    }

    function createBrand(string memory _name) external onlyOwner {
        require(bytes(_name).length > 0, "Invalid brand name");
        idBrand++;
        Brand memory brand = Brand({
            idBrand: idBrand,
            name: _name,
            amount: 0,
            active: true
        });
        brands[idBrand] = brand;
    }

    //@dev Link creator to a brand to get rewards
    function linkCreatorToBrand(uint256 _idBrand) external {
        require(brand.idBrand != 0, "Brand not found");
        Brand memory brand = brands[_idBrand];
        require(brand.active, "Brand is not active");
        creatorBrand[_idBrand] = _idBrand;
    }

    //@dev Function to distribute rewards to creators
    function distribute() external {
        require(IERC20(usdcToken).balanceOf(address(this)) > 0, "No funds to distribute");
        // distribute tokens - update amounts
    }

    //@dev Functions to withdraw funds for content creators
    function withdraw() external {
        require(amounts[msg.sender] > 0, "No funds to withdraw");
        amounts[msg.sender] = 0;
        IERC20(usdcToken).transfer(msg.sender, amounts[msg.sender]);
    }

    //@dev Function to withdraw tokens in case of emergency
    function emergencyWithdraw(address _token, uint256 _amount) external onlyOwner {
        IERC20(_token).transfer(msg.sender, _amount);
    }
    */
}
