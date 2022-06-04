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
  address constant NOT_OWNER = 0x016C8780e5ccB32E5CAA342a926794cE64d9C364;
  address constant NFTX_VAULT = 0xEA23AfF1724fe14c38BE4f4493f456Cac1AFEc0e;
  address constant FAKE_ERC721 = 0x2aEa4Add166EBf38b63d09a75dE1a7b94Aa24163;
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

    // Update approvals
    GOBLIN_MODE.setMaxApprovals();

    // Execute flashloan
    // Setup tokens
    uint256[] memory tokenIds = new uint256[](3);
    tokenIds[0] = 2578;
    tokenIds[1] = 9031;
    tokenIds[2] = 4070;
    // Generate calldata
    bytes[] memory data = new bytes[](3);
    for (uint256 i = 0; i < tokenIds.length; i++) {
      // Encode claim into data
      data[i] = abi.encodeWithSelector(
        bytes4(keccak256(bytes("claim(uint256)"))),
        tokenIds[i]
      );
    }
    GOBLIN_MODE.execute(
      tokenIds,
      address(MOCK_BURGER),
      data
    );

    // Verify final vToken balance
    assertEq(
      IERC20Balance(NFTX_VAULT).balanceOf(address(GOBLIN_MODE)),
      0
    );
    // Verify final MockBurger nft balance
    assertEq(MOCK_BURGER.balanceOf(address(GOBLIN_MODE)), 3);
  }

  /// @notice Failing flashloan execution (no NFTX fee balance)
  function testFailExecuteWithoutFee() public {
    // Update approvals
    GOBLIN_MODE.setMaxApprovals();

    // Execute flashloan (without fee, should fail)
    // Setup tokens
    uint256[] memory tokenIds = new uint256[](3);
    tokenIds[0] = 2578;
    tokenIds[1] = 9031;
    tokenIds[2] = 4070;
    // Generate calldata
    bytes[] memory data = new bytes[](3);
    for (uint256 i = 0; i < tokenIds.length; i++) {
      // Encode claim into data
      data[i] = abi.encodeWithSelector(
        bytes4(keccak256(bytes("claim(uint256)"))),
        tokenIds[i]
      );
    }
    GOBLIN_MODE.execute(
      tokenIds,
      address(MOCK_BURGER),
      data
    );
  }

  /// @notice Failing flashloan execution (non-owner)
  function testFailExecuteNotOwner() public {
    // Update approvals
    GOBLIN_MODE.setMaxApprovals();

    // Collect required fee
    VM.prank(0x9ECD4042Ce307A2eaee23061351f2A204279a207); // SushiSwap pool
    IERC20(NFTX_VAULT).transfer(
      address(GOBLIN_MODE),
      18e16 // 0.18
    );

    // Execute flashloan
    // Setup tokens
    uint256[] memory tokenIds = new uint256[](3);
    tokenIds[0] = 2578;
    tokenIds[1] = 9031;
    tokenIds[2] = 4070;
    // Generate calldata
    bytes[] memory data = new bytes[](3);
    for (uint256 i = 0; i < tokenIds.length; i++) {
      // Encode claim into data
      data[i] = abi.encodeWithSelector(
        bytes4(keccak256(bytes("claim(uint256)"))),
        tokenIds[i]
      );
    }
    // Mock non-owner
    VM.prank(NOT_OWNER);
    GOBLIN_MODE.execute(
      tokenIds,
      address(MOCK_BURGER),
      data
    );
  }

  /// @notice Successful withdraw by owner
  function testWithdrawTokens() public {
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

    // Ensure tokens are withdrawable
    GOBLIN_MODE.ownerWithdrawToken(
      NFTX_VAULT,
      18e16
    );
    assertEq(
      IERC20Balance(NFTX_VAULT).balanceOf(address(this)),
      18e16
    );
    assertEq(
      IERC20Balance(NFTX_VAULT).balanceOf(address(GOBLIN_MODE)),
      0
    );
  }

  /// @notice Failing withdraw by non-owner
  function testFailWithdrawTokensNotOwner() public {
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

    // Ensure tokens are not withdrawable
    VM.prank(NOT_OWNER);
    GOBLIN_MODE.ownerWithdrawToken(
      NFTX_VAULT,
      18e16
    );
  }

  /// @notice Successful withdraw by owner
  function testWithdrawNFTs() public {
    // Setup fake ERC721 token
    uint256[] memory tokenIds = new uint256[](1);
    tokenIds[0] = 2183;

    // Transfer dummy ERC721 to contract
    VM.prank(NOT_OWNER); // ironically, fake ERC721 owner
    IERC721(FAKE_ERC721).transferFrom(
      address(NOT_OWNER),
      address(GOBLIN_MODE),
      tokenIds[0]
    );

    // Ensure NFT is withdrawable
    GOBLIN_MODE.ownerWithdrawNFT(FAKE_ERC721, tokenIds);
  }

  /// @notice Failing withdraw by non-owner
  function testFailWithdrawNFTsNotOwner() public {
    // Setup fake ERC721 token
    uint256[] memory tokenIds = new uint256[](1);
    tokenIds[0] = 2183;

    // Transfer dummy ERC721 to contract
    VM.prank(NOT_OWNER); // ironically, fake ERC721 owner
    IERC721(FAKE_ERC721).transferFrom(
      address(NOT_OWNER),
      address(GOBLIN_MODE),
      tokenIds[0]
    );

    // Ensure NFT is not withdrawable
    VM.prank(NOT_OWNER);
    GOBLIN_MODE.ownerWithdrawNFT(FAKE_ERC721, tokenIds);
  }

  /// @notice Accept ERC721 tokens
  function onERC721Received(address, address, uint256, bytes calldata) 
    external pure returns (bytes4) {
    // IERC721.onERC721Received.selector
    return 0x150b7a02;
  }
}
