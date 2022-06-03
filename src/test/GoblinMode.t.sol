// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// ============ Imports ============

import "../GoblinMode.sol"; // GoblinMode
import "../MockBurger.sol"; // Mock claimable NFT
import "forge-std/Test.sol"; // Tests

interface IERC20Balance {
  /// @notice Returns token balance
  function balanceOf(address) external returns (uint256);
}

/// @title GoblinModeTest
/// @notice Tests GoblinMode.sol
contract GoblinModeTest is Test {
  // ============ Constants ============

  address constant VM_ADDR = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
  address constant NFTX_VAULT = 0xEA23AfF1724fe14c38BE4f4493f456Cac1AFEc0e;
  address constant GOBLIN_TOWN = 0xbCe3781ae7Ca1a5e050Bd9C4c77369867eBc307e;

  // ============ Storage ============

  /// @dev Cheatcodes
  Vm public VM;
  /// @dev Claimable NFT contract
  MockBurger public MOCK_BURGER;
  /// @dev Flashloan contract
  GoblinMode public GOBLIN_MODE;

  // ============ Setup tests ============

  function setUp() public {
    VM = Vm(VM_ADDR);
    MOCK_BURGER = new MockBurger(GOBLIN_TOWN);
    GOBLIN_MODE = new GoblinMode(
      GOBLIN_TOWN,
      address(MOCK_BURGER),
      NFTX_VAULT
    );
  }

  // ============ Tests ============

  /// @notice Successful flashloan execution
  function testExecute() public {
    // Send 0.18 vTokens to contract
    VM.prank(0x9ECD4042Ce307A2eaee23061351f2A204279a207); // SushiSwap pool
    IERC20(NFTX_VAULT).transfer(
      address(GOBLIN_MODE),
      18e16 // 0.18
    );
    assertEq(
      IERC20Balance(NFTX_VAULT).balanceOf(address(GOBLIN_MODE)),
      18e16
    );

    // Execute flashloan
    uint256[] memory tokenIds = new uint256[](3);
    tokenIds[0] = 5472;
    tokenIds[1] = 7605;
    tokenIds[2] = 1090;
    GOBLIN_MODE.execute(tokenIds);

    // Verify final vToken balance
    assertEq(
      IERC20Balance(NFTX_VAULT).balanceOf(address(GOBLIN_MODE)),
      0
    );
    // Verify final MockBurger nft balance
    assertEq(MOCK_BURGER.balanceOf(address(GOBLIN_MODE)), 3);
  }

  /// @notice Failing flashloan execution (no NFTX fee balance)
  /*function testFailExecuteWithoutFee() public {}

  /// @notice Successful withdraw by owner
  function testWithdrawTokens() public {}

  /// @notice Failing withdraw by non-owner
  function testWithdrawTokensNotOwner() public {}

  /// @notice Successful withdraw by owner
  function testWithdrawNFTs() public {}

  /// @notice Failing withdraw by non-owner
  function testWithdrawNFTsNotOwner() public {}*/
}
