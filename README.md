# goblinmode

goblinmode provides a `GoblinMode.sol` contract to flashloan [goblintown](https://goblintown.wtf/) NFTs from [NFTX](https://nftx.io/) to claim a [McGoblinBurger](https://twitter.com/McGoblinBurger) NFT.

Each claimed McGoblinBurger NFT costs `[0.06 * cost(goblintown)] + gas`, which is fairly cost effective given historic distributions between tokens like BAYC & MAYC.

This mint presents a unique opportunity, where:

- There is [significant](https://nftx.io/vault/0xea23aff1724fe14c38be4f4493f456cac1afec0e/buy/) NFTX liquidity for the flashloaned NFT (61+ NFTs at time of writing)
- There is [reasonably deep](https://app.sushi.com/swap?outputCurrency=ETH&inputCurrency=0xea23aff1724fe14c38be4f4493f456cac1afec0e) vToken liquidity in the SushiSwap pool
- There are [low flash loan fees (6%/NFT)](https://nftx.io/vault/0xea23aff1724fe14c38be4f4493f456cac1afec0e/info/) (not hiked up like usually done before popular derivative mints)
- There are enough NFTs in the NFTX pool to make it difficult to claim all derivative NFTs in one block
- The mint contracts are not known ahead of time (unknown function selector), significantly removing Flashbots pressure + levelling playing field

## Test

Tests use [Foundry: Forge](https://github.com/gakonst/foundry).

Install Foundry using the installation steps in the README of the linked repo.

```bash
# Get dependencies
forge update

# Run tests against mainnet fork
forge test --fork-url=YOUR_MAINNET_RPC_URL -vvvv
```

## Disclaimer

These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. Anish Agnihotri is not liable for any of the foregoing. Users should proceed with caution and use at their own risk.
