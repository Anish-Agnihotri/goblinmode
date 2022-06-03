// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// ============ Imports ============

import "solmate/tokens/ERC721.sol"; // Solmate: ERC721

/// ============ Interfaces ============

interface ExtendedERC721 {
  /// @notice Checks owner of NFT
  /// @param tokenId to check
  /// @return owner address
  function ownerOf(uint256 tokenId) external view returns (address owner);
}

/// @title MockBurger
/// @notice Mocks hypothetical functionality of a McGoblinBurger contract
contract MockBurger is ERC721("MockBurger", "MB") {
  // ============ Immutable storage ===========

  /// @dev goblintown NFT contract
  ExtendedERC721 public immutable GOBLIN_TOWN;

  // ============ Constructor ============

  /// @notice Creates a new MockBurger contract
  /// @param _GOBLIN_TOWN contract
  constructor(address _GOBLIN_TOWN) {
    GOBLIN_TOWN = ExtendedERC721(_GOBLIN_TOWN);
  }

  // ============ Functions ============

  /// @notice Arbitrary claim function
  /// @param tokenIds to claim
  function claim(uint256[] memory tokenIds) external {
    for (uint256 i = 0; i < tokenIds.length; i++) {
      // Require ownership of gobbler
      require(GOBLIN_TOWN.ownerOf(tokenIds[i]) == msg.sender, "oNlY foR GOblEn");
      // Mint new Mockburger NFT
      _mint(msg.sender, tokenIds[i]);
    }
  }

  /// @notice Implement mock tokenURI
  function tokenURI(uint256 id) public view override returns (string memory) {
    return "";
  }
}