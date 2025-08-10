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
    string public name = 'Sherry Beta Onboarding NFT';
    string public symbol = 'SHERRY';

    // Role definitions
    bytes32 public constant MINTER_ROLE = keccak256("MINTER");

    // One NFT per collection and per user tracking
     mapping(uint256 => mapping(address => bool)) public hasMinted;

    // Collection information for metadata
    struct CollectionInfo {
        string miniAppId;
        string twitterHandle;
        bool exists;
    }
    mapping(uint256 => CollectionInfo) public collectionInfo;

    // Events
    event CollectionCreated(
        uint256 indexed collectionId,
        string miniAppId,
        string twitterHandle
    );
    event CollectionMint(address indexed to, string miniAppId, string twitterHandle);

    // Custom errors
    error TransferNotAllowed();
    error CollectionNotExists();
    error AlreadyMinted();

    constructor(string memory uri, address minter) ERC1155(uri) {
        // Grant roles
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, minter);
    }

    /**
     * @dev Public mint function - anyone can mint one NFT per collection (max 3 per collection)
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

        // Mint the NFT (will be marked as soulbound in _update)
        _mint(to, collectionId, 1, "");

        emit CollectionMint(to, collectionInfo[collectionId].miniAppId, twitterHandle);
    }

    /**
     * @dev Creates a new collection for specific mini app
     * @param collectionId Unique identifier for the collection
     * @param miniAppId Display mini-app id of the collection
     * @param twitterHandle Display twitter handle of the mini app creator
     * @param to Owner of the collection, used to self mint
     */
    function createCollection(
        uint256 collectionId,
        string calldata miniAppId,
        string calldata twitterHandle,
        address to
    ) external onlyRole(MINTER_ROLE) {
        if (collectionInfo[collectionId].exists) revert CollectionNotExists();
        collectionInfo[collectionId] = CollectionInfo({
            miniAppId: miniAppId,
            twitterHandle: twitterHandle,
            exists: true
        });

        // Self mint nft
        mint(collectionId, twitterHandle, to);

        emit CollectionCreated(collectionId, miniAppId, twitterHandle);
    }

    /**
     * @dev Get collection information
     */
    function getCollectionInfo(
        uint256 collectionId
    ) external view returns (CollectionInfo memory) {
        if (!collectionInfo[collectionId].exists) revert CollectionNotExists();
        return collectionInfo[collectionId];
    }

    // Admin functions
    function setMinterRole(address minter) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, minter);
    }

    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    function setURI(string memory newuri) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _setURI(newuri);
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
}
