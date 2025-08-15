// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title SherryBetaOnboarding
 * @dev Soulbound NFT badges for Sherry Beta Activation System
 * @notice NFTs are non-transferable once minted by users (soulbound)
 */
contract SherryBetaOnboarding is
    ERC1155,
    ERC1155Supply,
    AccessControl,
    Pausable,
    ReentrancyGuard
{
    // Token metadata
    string public name = "Sherry Beta Onboarding NFT";
    string public symbol = "SHERRY";

    // Role definitions
    bytes32 public constant MINTER_ROLE = keccak256("MINTER");

    // Auto-incrementing counter for collection IDs
    uint256 private _collectionIdCounter;

    // One NFT per collection and per user tracking
    mapping(uint256 => mapping(address => bool)) public hasMinted;

    // Collection information for metadata
    struct CollectionInfo {
        string miniAppId;
        string twitterHandle;
        string metadataURI;
        address creator;
        uint256 createdAt;
        bool exists;
    }
    mapping(uint256 => CollectionInfo) public collectionInfo;

    // Mapping from miniAppId to collectionId for uniqueness check
    mapping(string => uint256) public miniAppIdToCollection;
    mapping(string => bool) public miniAppIdExists;

    // Events
    event CollectionCreated(
        uint256 indexed collectionId,
        string miniAppId,
        string twitterHandle,
        address indexed creator
    );
    event CollectionMint(
        address indexed to,
        string miniAppId,
        string twitterHandle
    );

    // Custom errors
    error TransferNotAllowed();
    error AlreadyMinted();
    error MiniAppIdAlreadyExists();
    error CollectionNotExists();

    constructor(address minter) ERC1155("") {
        // Grant roles
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, minter);
        
        // Start counter at 1 (0 can be reserved for special cases)
        _collectionIdCounter = 1;
    }

    /**
     * @dev Create collection and mint NFT in one transaction
     * @param miniAppId Mini-app identifier (must be unique)
     * @param twitterHandle Twitter username
     * @param metadataURI Metadata URI (only used if collection doesn't exist)
     * @param to Minter address
     * @return collectionId The collection ID (existing or newly created)
     */
    function createCollectionAndMint(
        string calldata miniAppId,
        string calldata twitterHandle,
        string calldata metadataURI,
        address to
    ) external nonReentrant whenNotPaused onlyRole(MINTER_ROLE) returns (uint256) {
        uint256 collectionId;

        // Check if collection already exists
        if (miniAppIdExists[miniAppId]) {
            // Collection exists, get the ID
            collectionId = miniAppIdToCollection[miniAppId];
        } else {
            // Collection doesn't exist, create it
            collectionId = _collectionIdCounter;
            _collectionIdCounter++;

            // Create collection
            collectionInfo[collectionId] = CollectionInfo({
                miniAppId: miniAppId,
                twitterHandle: twitterHandle,
                metadataURI: metadataURI,
                creator: msg.sender,
                createdAt: block.timestamp,
                exists: true
            });

            // Mark miniAppId as used
            miniAppIdExists[miniAppId] = true;
            miniAppIdToCollection[miniAppId] = collectionId;

            emit CollectionCreated(collectionId, miniAppId, twitterHandle, msg.sender);
        }

        // Check if user already minted from this collection
        if (hasMinted[collectionId][to]) revert AlreadyMinted();

        // Mark as minted for this user
        hasMinted[collectionId][to] = true;

        // Mint the NFT
        _mint(to, collectionId, 1, "");

        emit CollectionMint(to, miniAppId, twitterHandle);

        return collectionId;
    }

    /**
     * @dev Mint from existing collection using collectionId
     * @param collectionId The collection to mint from
     * @param twitterHandle Twitter username of the minter
     * @param to Minter address
     */
    function mint(
        uint256 collectionId,
        string calldata twitterHandle,
        address to
    ) public nonReentrant whenNotPaused onlyRole(MINTER_ROLE) {
        if (!collectionInfo[collectionId].exists) revert CollectionNotExists();
        if (hasMinted[collectionId][to]) revert AlreadyMinted();

        // Mark as minted for this user
        hasMinted[collectionId][to] = true;

        // Mint the NFT
        _mint(to, collectionId, 1, "");

        emit CollectionMint(
            to,
            collectionInfo[collectionId].miniAppId,
            twitterHandle
        );
    }

    /**
     * @dev Mint from existing collection using miniAppId
     * @param miniAppId The mini app ID to mint from
     * @param twitterHandle Twitter username of the minter
     * @param to Minter address
     */
    function mintByMiniAppId(
        string calldata miniAppId,
        string calldata twitterHandle,
        address to
    ) external nonReentrant whenNotPaused onlyRole(MINTER_ROLE) {
        if (!miniAppIdExists[miniAppId]) revert CollectionNotExists();
        
        uint256 collectionId = miniAppIdToCollection[miniAppId];
        mint(collectionId, twitterHandle, to);
    }

    /**
     * @dev Creates a new collection without minting
     * @param miniAppId Mini-app identifier (must be unique)
     * @param twitterHandle Twitter username
     * @param metadataURI Metadata URI
     * @return collectionId The auto-generated collection ID
     */
    function createCollection(
        string calldata miniAppId,
        string calldata twitterHandle,
        string calldata metadataURI
    ) external onlyRole(MINTER_ROLE) returns (uint256) {
        // Check miniAppId is unique
        if (miniAppIdExists[miniAppId]) revert MiniAppIdAlreadyExists();

        // Get new collection ID
        uint256 newCollectionId = _collectionIdCounter;
        _collectionIdCounter++;

        // Create collection
        collectionInfo[newCollectionId] = CollectionInfo({
            miniAppId: miniAppId,
            twitterHandle: twitterHandle,
            metadataURI: metadataURI,
            creator: msg.sender,
            createdAt: block.timestamp,
            exists: true
        });

        // Mark miniAppId as used
        miniAppIdExists[miniAppId] = true;
        miniAppIdToCollection[miniAppId] = newCollectionId;

        emit CollectionCreated(newCollectionId, miniAppId, twitterHandle, msg.sender);

        return newCollectionId;
    }

    /**
     * @dev Get collection information by ID
     */
    function getCollectionInfo(
        uint256 collectionId
    ) external view returns (CollectionInfo memory) {
        if (!collectionInfo[collectionId].exists) revert CollectionNotExists();
        return collectionInfo[collectionId];
    }

    /**
     * @dev Get collection information by miniAppId
     */
    function getCollectionByMiniAppId(
        string calldata miniAppId
    ) external view returns (CollectionInfo memory) {
        if (!miniAppIdExists[miniAppId]) revert CollectionNotExists();
        uint256 collectionId = miniAppIdToCollection[miniAppId];
        return collectionInfo[collectionId];
    }

    /**
     * @dev Get current collection counter (next ID to be assigned)
     */
    function getCurrentCollectionId() external view returns (uint256) {
        return _collectionIdCounter;
    }

    /**
     * @dev Check if a collection exists by ID
     */
    function collectionExists(uint256 collectionId) external view returns (bool) {
        return collectionInfo[collectionId].exists;
    }

    /**
     * @dev Check if a miniAppId exists
     */
    function miniAppExists(string calldata miniAppId) external view returns (bool) {
        return miniAppIdExists[miniAppId];
    }

    // Admin functions
    function setMinterRole(
        address minter
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, minter);
    }

    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    function setURI(
        string memory newuri
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _setURI(newuri);
    }

    /**
     * @dev Emergency function to set collection counter (admin only)
     */
    function setCollectionIdCounter(
        uint256 newCounter
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _collectionIdCounter = newCounter;
    }

    // Override functions for soulbound functionality
    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155, ERC1155Supply) whenNotPaused {
        // Only allow minting from == address(0)
        if (from != address(0)) {
            revert TransferNotAllowed();
        }

        super._update(from, to, ids, values);
    }

    // Override for interface support
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // Override to build full URI from baseURI variable
    function uri(uint256 tokenId) public view override returns (string memory) {
        if (!collectionInfo[tokenId].exists) revert CollectionNotExists();
        return collectionInfo[tokenId].metadataURI;
    }
}