// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// ============ Imports ============

import "../GoblinMode.sol"; // GoblinMode
import "../MockBurger.sol"; // Mock claimable NFT
import "forge-std/Test.sol"; // Tests

/// @title GoblinModeTest
/// @notice Tests GoblinMode.sol
contract GoblinModeTest is Test {
  // ============ Constants ============

  address constant NFTX_VAULT = 0xEA23AfF1724fe14c38BE4f4493f456Cac1AFEc0e;
  address constant GOBLIN_TOWN = 0xbCe3781ae7Ca1a5e050Bd9C4c77369867eBc307e;

  // ============ Storage ============

  /// @dev Claimable NFT contract
  MockBurger public MOCK_BURGER;
  /// @dev Flashloan contract
  GoblinMode public GOBLIN_MODE;

  // ============ Setup tests ============

  function setUp() public {
    MOCK_BURGER = new MockBurger(GOBLIN_TOWN);
    GOBLIN_MODE = new GoblinMode(
      GOBLIN_TOWN,
      address(MOCK_BURGER),
      NFTX_VAULT
    );
  }

  // ============ Tests ============

  /// @notice Successful flashloan execution
  function testExecute() public {}

  /// @notice Failing flashloan execution (no NFTX fee balance)
  function testFailExecuteWithoutFee() public {}

  /// @notice Successful withdraw by owner
  function testWithdrawTokens() public {}

  /// @notice Failing withdraw by non-owner
  function testWithdrawTokensNotOwner() public {}

  /// @notice Successful withdraw by owner
  function testWithdrawNFTs() public {}

  /// @notice Failing withdraw by non-owner
  function testWithdrawNFTsNotOwner() public {}
}
