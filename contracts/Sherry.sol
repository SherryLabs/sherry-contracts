// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { IBrand } from "./interface/IBrand.sol";
import { ICampaign } from "./interface/ICampaign.sol";
import { IKOL } from "./interface/IKOL.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract Sherry {
    Brand public s_brandContract;
    Campaign public s_campaignContract;
    KOL public s_kolContract;

    constructor(
        address _brandContract,
        address _campaignContract,
        address _kolContract
    ) Ownable(msg.sender) {
        require(_brandContract != address(0), "Invalid brand contract address");
        require(
            _campaignContract != address(0),
            "Invalid campaign contract address"
        );
        require(_kolContract != address(0), "Invalid KOL contract address");
        s_brandContract = Brand(_brandContract);
        s_campaignContract = Campaign(_campaignContract);
        s_kolContract = KOL(_kolContract);
    }
    
}