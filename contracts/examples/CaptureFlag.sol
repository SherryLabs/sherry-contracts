// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract CaptureFlag {
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

    modifier canParticipate(){
        require(block.timestamp >= lastParticipationTime[msg.sender] + 10 minutes, "Wait 10 minutes before participating again");
        _;
    }

    function joinGame() external payable canParticipate(){
        require(msg.value >= gameFee, "Insufficient fee");

        lastParticipationTime[msg.sender] = block.timestamp;
        emit GameJoined(msg.sender, block.timestamp);
    }

    function captureFlag() public canParticipate {
        require(flagHolder != msg.sender, "You already have the flag");
        require(flagCaptureTime + 1 hours < block.timestamp, "Flag can only be captured after 1 hour");

        flagHolder = msg.sender;
        flagCaptureTime = block.timestamp;
        lastParticipationTime[msg.sender] = block.timestamp;

        emit FlagCaptured(msg.sender, block.timestamp);
    }

    function updateGameFee(uint256 _gameFee) external onlyOwner {
        gameFee = _gameFee;
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}