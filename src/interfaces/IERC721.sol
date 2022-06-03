// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// @title IERC721
/// @notice Minimal ERC721 interface
interface IERC721 {
  /// @notice Approve spend for all tokens
  /// @param operator to approve
  /// @param approved status
  function setApprovalForAll(address operator, bool approved) external;
  /// @notice Transfer NFT
  /// @param from address
  /// @param to address
  /// @param tokenId to transfer
  function transferFrom(address from, address to, uint256 tokenId) external;
}