// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// ============ Interfaces ============

import "./IERC3156FlashBorrower.sol"; // IERC3156FlashBorrower

/// @title NFTXVault
/// @notice NFTX vToken/Vault interface
interface NFTXVault {
  /// @notice Allows redeeming NFTs from vault
  /// @param amount number to redeem
  /// @param specificIds optional ids to redeem
  function redeem(
    uint256 amount, 
    uint256[] calldata specificIds
  ) external returns (uint256[] memory);
  /// @notice Allows minting vToken by transferring NFTs into vault
  /// @param tokenIds to deposit
  /// @param amounts empty for ERC721 tokens (used for ERC1155 amounts)
  function mint(
    uint256[] calldata tokenIds,
    uint256[] calldata amounts
  ) external returns (uint256);
  /// @notice Request flash loan from vault
  /// @param receiver recipient of tokens
  /// @param token to flashloan
  /// @param amount to flashloan
  /// @param data passed via return callback
  function flashLoan(
    IERC3156FlashBorrower receiver,
    address token,
    uint256 amount,
    bytes calldata data
  ) external returns (bool);
  /// @notice Allow spending balance
  /// @param spender approved address
  /// @param amount to approve for
  function approve(address spender, uint256 amount) external;
}