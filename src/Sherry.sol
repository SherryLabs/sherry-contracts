// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {IBrand} from "./interface/IBrand.sol";
import {ICampaign} from "./interface/ICampaign.sol";
import {IKOL} from "./interface/IKOL.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Sherry is Ownable {
    IBrand public i_brandContract;
    ICampaign public i_campaignContract;
    IKOL public i_kolContract;

    constructor(address _brandContract, address _campaignContract, address _kolContract) Ownable(msg.sender) {
        require(_brandContract != address(0), "Invalid brand contract address");
        require(_campaignContract != address(0), "Invalid campaign contract address");
        require(_kolContract != address(0), "Invalid KOL contract address");
        i_brandContract = IBrand(_brandContract);
        i_campaignContract = ICampaign(_campaignContract);
        i_kolContract = IKOL(_kolContract);
    }
}
