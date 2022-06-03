// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// ============ Interfaces ============

import "./interfaces/IERC20.sol"; // ERC20
import "./interfaces/IERC721.sol"; // ERC721
import "./interfaces/NFTXVault.sol"; // NFTXVault
import "./interfaces/IERC3156FlashBorrower.sol"; // EIP-3156 Flash Borrower

/// ============ Custom Interfaces ============

/// @title GoblinMode
/// @author Anish Agnihotri
/// @notice Claims McGoblinBurger NFTs via NFTX flashloaning goblintown NFTs
contract GoblinMode is IERC3156FlashBorrower {
  // ============ Immutable storage ============

  /// @dev Contract owner
  address internal immutable OWNER;
  /// @dev GoblinTown NFTs
  IERC721 internal immutable GOBLIN_TOWN;
  /// @dev NFTX Vault
  NFTXVault internal immutable GOBLIN_TOWN_VAULT;

  // ============ Modifiers ============

  /// @notice Restrict to owner
  modifier onlyOwner() {
    require(msg.sender == OWNER, "UNAUTHORIZED");
    _;
  }

  // ============ Constructor ============

  /// @notice Creates a new GoblinMode contract
  /// @param _GOBLIN_TOWN contract
  /// @param _GOBLIN_TOWN_VAULT nftx vault
  constructor(address _GOBLIN_TOWN, address _GOBLIN_TOWN_VAULT) {
    OWNER = msg.sender; // Setup owner

    // Setup NFT + Vault contracts
    GOBLIN_TOWN = IERC721(_GOBLIN_TOWN);
    GOBLIN_TOWN_VAULT = NFTXVault(_GOBLIN_TOWN_VAULT);

    // Approve NFTX vault to transfer goblintown nfts
    GOBLIN_TOWN.setApprovalForAll(
      address(GOBLIN_TOWN_VAULT),
      true
    );
    // Approve NFTX vault to reclaim vTokens
    GOBLIN_TOWN_VAULT.approve(
      address(GOBLIN_TOWN_VAULT),
      type(uint256).max
    );
  }

  // ============ Functions ============

  /// @notice Executes strategy
  /// @param tokenIds to flashloan from NFTX Vault
  /// @param mcGoblinBurger address to derivative NFT
  /// @param claimData to execute at derivative NFT address
  function execute(
    uint256[] memory tokenIds, 
    address mcGoblinBurger,
    bytes memory claimData
  ) external onlyOwner {
    GOBLIN_TOWN_VAULT.flashLoan(
      IERC3156FlashBorrower(address(this)), // Receiver = this contract
      address(GOBLIN_TOWN_VAULT), // Token to flash loan (goblintown vToken)
      tokenIds.length * 1e18, // 1 token per NFT
      abi.encode(tokenIds, mcGoblinBurger, claimData)
    );
  }

  /// @notice Receive a flashloan
  /// @dev Described in interface specification
  function onFlashLoan(
    address,
    address,
    uint256,
    uint256,
    bytes calldata data
  ) external returns (bytes32) {
    // Enforce callback caller is NFTX pool
    require(msg.sender == address(GOBLIN_TOWN_VAULT), "UNAUTHORIZED");

    // Decode calldata to get tokenIds, derivative address, function data
    (
      uint256[] memory tokenIds,
      address mcGoblinBurger,
      bytes memory claimData
    ) = abi.decode(data, (uint256[], address, bytes));

    // Redeem McGoblinBurger NFTs
    GOBLIN_TOWN_VAULT.redeem(tokenIds.length, tokenIds);

    // Claim NFTs by calling derivative contract with arbitrary data
    (bool success, ) = mcGoblinBurger.call(claimData);
    require(success, "UNSUCCESSFUL");

    // Return McGoblinBurger NFTs
    uint256[] memory empty = new uint256[](0);
    GOBLIN_TOWN_VAULT.mint(tokenIds, empty);

    return keccak256("ERC3156FlashBorrower.onFlashLoan");
  }

  /// @notice Allow owner to move contract tokens
  /// @param token contract address to transfer
  /// @param amount value to transfer
  function ownerWithdrawToken(address token, uint256 amount) external onlyOwner {
    IERC20(token).transfer(OWNER, amount);
  }

  /// @notice Allow owner to move contract NFTs
  /// @param token contract address to transfer
  /// @param tokenIds NFT IDs to transfer
  function ownerWithdrawNFT(
    address token, 
    uint256[] memory tokenIds
  ) external onlyOwner {
    uint256 length = tokenIds.length;
    for (uint256 i = 0; i < length;) {
      IERC721(token).transferFrom(address(this), OWNER, tokenIds[i]);
      unchecked { ++i; }
    }
  }

  /// @notice Accept ERC721 tokens
  function onERC721Received(address, address, uint256, bytes calldata) 
    external pure returns (bytes4) {
    // IERC721.onERC721Received.selector
    return 0x150b7a02;
  }
}
