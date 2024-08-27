# truster

```
function test_truster() public checkSolvedByPlayer {
        Truster truster = new Truster();
        truster.attack(pool,token,recovery);
    }
```

It is possible to redirect the call to any other contract and it will have msg.sender of that contract, we redirected to the token contract and gave to the desired allowance contract

```
function flashLoan(uint256 amount, address borrower, address target, bytes calldata data)
        external
        nonReentrant
        returns (bool)
    {
        uint256 balanceBefore = token.balanceOf(address(this));

        token.transfer(borrower, amount);
        target.functionCall(data);
```