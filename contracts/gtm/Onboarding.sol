// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/**
 * @title Onboarding
 * @dev Cross-chain onboarding contract for mini-apps on Celo
 * Receives interactions from Avalanche via SL1MessageReceiver and mints POAPs for user onboarding
 */
contract Onboarding {
    struct UserInteraction {
        address sender;           // Original sender from Avalanche
        bytes32 miniAppId;       // Hashed mini-app ID
        bytes32 twitterHandle;   // Hashed twitter handle (without @)
        uint256 timestamp;       // When the interaction occurred
        bool poapMinted;         // Whether POAP was minted for this interaction
    }
    
    // Storage
    mapping(bytes32 => UserInteraction) public interactions; // interactionId => UserInteraction
    mapping(bytes32 => uint256) public miniAppInteractionCount; // miniAppId => count
    mapping(address => bytes32[]) public userInteractions; // user => interactionIds
    mapping(bytes32 => bool) public miniAppExists; // miniAppId => exists
    
    // Counters
    uint256 public totalInteractions;
    uint256 public totalMiniApps;
    uint256 public totalPoapsMinted;
    
    // Configuration
    uint256 public constant MAX_MINI_APPS = 50;
    address public poapContract; // POAP contract address on Celo
    address public owner;
    address public messageReceiver; // SL1MessageReceiver contract address
    
    // Events
    event MiniAppCreated(
        bytes32 indexed miniAppId,
        address indexed creator,
        uint256 timestamp
    );
    
    event UserOnboarded(
        bytes32 indexed interactionId,
        address indexed sender,
        bytes32 indexed miniAppId,
        bytes32 twitterHandle,
        uint256 timestamp
    );
    
    event PoapMinted(
        bytes32 indexed interactionId,
        address indexed user,
        bytes32 indexed miniAppId,
        uint256 tokenId
    );
    
    event PoapContractUpdated(
        address indexed oldContract,
        address indexed newContract
    );
    
    constructor(address _messageReceiver) {
        owner = msg.sender;
        messageReceiver = _messageReceiver;
    }
    
    /**
     * @notice Creates a new mini-app
     * @param miniAppIdString The mini-app ID string to be hashed
     */
    function createMiniApp(string memory miniAppIdString) external {
        require(totalMiniApps < MAX_MINI_APPS, "Maximum mini-apps reached");
        
        bytes32 miniAppId = keccak256(abi.encodePacked(miniAppIdString));
        require(!miniAppExists[miniAppId], "Mini-app already exists");
        
        miniAppExists[miniAppId] = true;
        totalMiniApps++;
        
        emit MiniAppCreated(miniAppId, msg.sender, block.timestamp);
    }
    
    /**
     * @notice Processes cross-chain interaction from Avalanche
     * @dev This is called by SL1MessageReceiver when someone interacts with a mini-app
     * @param sender The user who interacted with the mini-app
     * @param miniAppIdString The mini-app ID string
     * @param twitterHandleString The twitter handle (without @)
     */
    function processOnboardingInteraction(
        address sender,
        string memory miniAppIdString,
        string memory twitterHandleString
    ) external {
        require(
            msg.sender == messageReceiver,
            "Only the message receiver can call this function"
        );
        
        _processUserInteraction(sender, miniAppIdString, twitterHandleString);
    }
    
    /**
     * @notice Processes a user interaction with a mini-app
     * @param sender The user who interacted with the mini-app
     * @param miniAppIdString The mini-app ID string
     * @param twitterHandleString The twitter handle (without @)
     */
    function _processUserInteraction(
        address sender,
        string memory miniAppIdString,
        string memory twitterHandleString
    ) internal {
        bytes32 miniAppId = keccak256(abi.encodePacked(miniAppIdString));
        bytes32 twitterHandle = keccak256(abi.encodePacked(twitterHandleString));
        
        require(miniAppExists[miniAppId], "Mini-app does not exist");
        require(bytes(twitterHandleString).length > 0, "Twitter handle required");
        
        // Create unique interaction ID
        bytes32 interactionId = keccak256(abi.encodePacked(
            sender,
            miniAppId,
            twitterHandle,
            block.timestamp,
            totalInteractions
        ));
        
        // Store interaction
        interactions[interactionId] = UserInteraction({
            sender: sender,
            miniAppId: miniAppId,
            twitterHandle: twitterHandle,
            timestamp: block.timestamp,
            poapMinted: false
        });
        
        // Update counters
        miniAppInteractionCount[miniAppId]++;
        userInteractions[sender].push(interactionId);
        totalInteractions++;
        
        emit UserOnboarded(
            interactionId,
            sender,
            miniAppId,
            twitterHandle,
            block.timestamp
        );
        
        // Attempt to mint POAP
        _mintPoap(interactionId, sender, miniAppId);
    }
    
    /**
     * @notice Mints POAP for successful interaction
     * @param interactionId The interaction ID
     * @param user The user to mint POAP for
     * @param miniAppId The mini-app ID
     */
    function _mintPoap(
        bytes32 interactionId,
        address user,
        bytes32 miniAppId
    ) internal {
        if (poapContract == address(0)) {
            return; // POAP contract not set
        }
        
        // TODO: Implement actual POAP minting logic
        // For now, we'll just mark as minted and emit event
        interactions[interactionId].poapMinted = true;
        totalPoapsMinted++;
        
        // Mock token ID - in real implementation, get from POAP contract
        uint256 tokenId = totalPoapsMinted;
        
        emit PoapMinted(interactionId, user, miniAppId, tokenId);
    }
    
    /**
     * @notice Sets the POAP contract address
     * @param _poapContract The POAP contract address
     */
    function setPoapContract(address _poapContract) external onlyOwner {
        address oldContract = poapContract;
        poapContract = _poapContract;
        emit PoapContractUpdated(oldContract, _poapContract);
    }
    
    /**
     * @notice Gets user interactions
     * @param user The user address
     * @return Array of interaction IDs
     */
    function getUserInteractions(address user) external view returns (bytes32[] memory) {
        return userInteractions[user];
    }
    
    /**
     * @notice Gets mini-app interaction count
     * @param miniAppIdString The mini-app ID string
     * @return The number of interactions for this mini-app
     */
    function getMiniAppInteractionCount(string memory miniAppIdString) external view returns (uint256) {
        bytes32 miniAppId = keccak256(abi.encodePacked(miniAppIdString));
        return miniAppInteractionCount[miniAppId];
    }
    
    /**
     * @notice Checks if a mini-app exists
     * @param miniAppIdString The mini-app ID string
     * @return Whether the mini-app exists
     */
    function doesMiniAppExist(string memory miniAppIdString) external view returns (bool) {
        bytes32 miniAppId = keccak256(abi.encodePacked(miniAppIdString));
        return miniAppExists[miniAppId];
    }
    
    /**
     * @notice Gets contract statistics
     * @return totalInteractions_ Total number of interactions
     * @return totalMiniApps_ Total number of mini-apps
     * @return totalPoapsMinted_ Total POAPs minted
     * @return availableSlots Remaining mini-app slots
     */
    function getStats() external view returns (
        uint256 totalInteractions_,
        uint256 totalMiniApps_,
        uint256 totalPoapsMinted_,
        uint256 availableSlots
    ) {
        return (
            totalInteractions,
            totalMiniApps,
            totalPoapsMinted,
            MAX_MINI_APPS - totalMiniApps
        );
    }
    
    /**
     * @notice Emergency function to process local interactions (for testing)
     * @param miniAppIdString The mini-app ID string
     * @param twitterHandleString The twitter handle
     */
    function processLocalInteraction(
        string memory miniAppIdString,
        string memory twitterHandleString
    ) external {
        _processUserInteraction(msg.sender, miniAppIdString, twitterHandleString);
    }
    
    /**
     * @notice Sets the message receiver contract address
     * @param _messageReceiver New message receiver address
     */
    function setMessageReceiver(address _messageReceiver) external onlyOwner {
        messageReceiver = _messageReceiver;
    }
    
    /**
     * @dev Modifier to restrict function access to the contract owner
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}