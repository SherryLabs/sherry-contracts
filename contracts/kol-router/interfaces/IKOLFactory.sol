// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IKOLFactory {
    function getKOLFeeRate() external view returns (uint16);
    function getFoundationFeeRate() external view returns (uint16);
    function getTreasuryFeeRate() external view returns (uint16);
    function getBasisPoints() external view returns (uint16);
    function getTotalFeeRate() external view returns (uint16);
}