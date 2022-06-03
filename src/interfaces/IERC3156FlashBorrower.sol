// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// @title IERC3156FlashBorrower
/// @notice Standard ERC3156 FlashBorrower
interface IERC3156FlashBorrower {
  /// @notice Receive a flashloan
  /// @param initiator loan initiator
  /// @param token currency
  /// @param amount lent
  /// @param fee to repay
  /// @param data arbritray data
  /// @return IERC3156FlashBorrower.onFlashLoan
  function onFlashLoan(
    address initiator,
    address token,
    uint256 amount,
    uint256 fee,
    bytes calldata data
  ) external returns (bytes32);
}