// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTGunzilla is ERC721 {
    uint256 private _nextTokenId;
    string private uri = "https://ipfs.io/ipfs/QmVtJ2HkKNeJaxpZtmnNuH7DeLzTYkkRjRym2dMk4Z74Wm";

    constructor()
        ERC721("NFTGunzilla", "GUN")
        
    {}

    function safeMint(address to) public  {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 _tokenId) public view override returns(string memory){
        return uri;
    } 
}
