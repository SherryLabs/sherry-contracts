// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract CaptureFlagWH {
    address public owner;
    uint256 public gameFee = 0.01 ether;
    address public flagHolder;
    uint256 public flagCaptureTime;

    mapping(address => uint256) public lastParticipationTime;

    event GameJoined(address indexed player, uint256 timestamp);
    event FlagCaptured(address indexed player, uint256 timestamp);

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier canParticipate(address _participant){
        require(block.timestamp >= lastParticipationTime[_participant] + 10 minutes, "Wait 10 minutes before participating again");
        _;
    }

    function joinGame(address _participant) external canParticipate(_participant){
        lastParticipationTime[_participant] = block.timestamp;
        emit GameJoined(_participant, block.timestamp);
    }

    function captureFlag(address _participant) public canParticipate(_participant) {
        require(flagHolder != _participant, "You already have the flag");
        require(flagCaptureTime + 1 hours < block.timestamp, "Flag can only be captured after 1 hour");

        flagHolder = _participant;
        flagCaptureTime = block.timestamp;
        lastParticipationTime[_participant] = block.timestamp;

        emit FlagCaptured(_participant, block.timestamp);
    }

    function updateGameFee(uint256 _gameFee) external onlyOwner {
        gameFee = _gameFee;
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}