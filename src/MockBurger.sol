// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// ============ Interfaces ============

interface ExtendedERC721 {
  /// @notice Checks owner of NFT
  /// @param tokenId to check
  /// @return owner address
  function ownerOf(uint256 tokenId) external view returns (address owner);
}

/// @title MockBurger
/// @notice Mocks hypothetical functionality of a McGoblinBurger contract
contract MockBurger {
  // ============ Immutable storage ===========

  /// @dev goblintown NFT contract
  ExtendedERC721 public immutable GOBLIN_TOWN;

  // ============ Constructor ============

  /// @notice Creates a new MockBurger contract
  /// @param _GOBLIN_TOWN contract
  constructor(address _GOBLIN_TOWN) {
    GOBLIN_TOWN = ExtendedERC721(_GOBLIN_TOWN);
  }

  /// @notice Arbitrary claim function
  function claim(uint256[] memory tokenIds) external {
    for (uint256 i = 0; i < tokenIds.length; i++) {
      // Require ownership of gobbler
      require(GOBLIN_TOWN.ownerOf(tokenIds[i]) == msg.sender, "oNlY foR GOblEn");
      // Mint new Mockburger NFT
    }
  }
}