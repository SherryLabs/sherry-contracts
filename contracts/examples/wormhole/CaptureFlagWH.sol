// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract CaptureFlagWH {
    address public owner;
    address public flagHolder;
    uint256 public flagCaptureTime;
    uint256 public flagPrice = 0.1 ether;

    mapping(address => uint256) public lastParticipationTime;

    event FlagCaptured(address indexed player, uint256 timestamp);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier canParticipate(address _participant){
        require(block.timestamp >= lastParticipationTime[_participant] + 10 minutes, "Wait 10 minutes before participating again");
        _;
    }

    function captureFlag(address _participant) public payable canParticipate(_participant) {
        require(msg.value >= flagPrice, "Insufficient funds");
        require(flagHolder != _participant, "You already have the flag");
        require(flagCaptureTime + 1 minutes < block.timestamp, "Flag can only be captured after 1 minute");

        flagHolder = _participant;
        flagCaptureTime = block.timestamp;
        lastParticipationTime[_participant] = block.timestamp;
        emit FlagCaptured(_participant, block.timestamp);
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function canUserParticipate(address _participant) external view returns(bool){
        return block.timestamp >= lastParticipationTime[_participant] + 10 minutes;
    }

    function setFlagPrice(uint256 _price) external onlyOwner {
        flagPrice = _price;
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }
}