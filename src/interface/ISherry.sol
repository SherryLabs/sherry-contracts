// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/// @title ISherry Interface
/// @notice This interface defines the structure and events for the Sherry contract.
/// @dev This interface includes functions for creating posts, voting, and retrieving URIs.
interface ISherry {
    /// @notice Represents a post in the Sherry contract.
    /// @param idKolCampaign The ID of the KOL campaign.
    /// @param kol The address of the KOL.
    /// @param idCampaign The ID of the campaign.
    /// @param url The URL associated with the post.
    struct Post {
        uint256 idKolCampaign;
        address kol;
        uint256 idCampaign;
        string url;
    }

    /// @notice Emitted when a vote is cast on a post.
    /// @param idPost The ID of the post that was voted on.
    /// @param voter The address of the voter.
    event Voted(uint256 indexed idPost, address indexed voter);

    /// @notice Emitted when a new post is created.
    /// @param idPost The ID of the newly created post.
    /// @param kol The address of the KOL who created the post.
    /// @param idCampaign The ID of the campaign associated with the post.
    /// @param url The URL of the newly created post.
    event postCreated(uint256 indexed idPost, address indexed kol, uint256 indexed idCampaign, string url);

    /// @notice Creates a new post.
    /// @param _idKolCampaign The ID of the KOL campaign.
    /// @param _url The URL of the post.
    function createPost(uint256 _idKolCampaign, string memory _url) external;

    /// @notice Casts a vote on a post.
    /// @param _idPost The ID of the post to vote on.
    /// @return A boolean indicating whether the vote was successful.
    function vote(uint256 _idPost) external returns (bool);

    /// @notice Retrieves the URI of a post.
    /// @param _idPost The ID of the post.
    /// @return The URI of the post as a string.
    function getUri(uint256 _idPost) external view returns (string memory);
}
