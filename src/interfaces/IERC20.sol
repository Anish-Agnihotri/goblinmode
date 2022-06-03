// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// @title IERC20
/// @notice Minimal ERC721 interface
interface IERC20 {
  /// @notice Transfer tokens
  /// @param recipient receiver
  /// @param amount to transfer
  function transfer(address recipient, uint256 amount) external;
}