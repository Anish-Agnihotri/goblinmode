// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../GoblinMode.sol";
import "forge-std/Test.sol";

contract ContractTest is Test {
    GoblinMode public arbitrage;

    function setUp() public {
        arbitrage = new GoblinMode(
            0xbCe3781ae7Ca1a5e050Bd9C4c77369867eBc307e,
            0xEA23AfF1724fe14c38BE4f4493f456Cac1AFEc0e
        );
    }

    function testExample() public {
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 9467;
        arbitrage.execute(tokenIds);
        assertTrue(true);
    }
}
