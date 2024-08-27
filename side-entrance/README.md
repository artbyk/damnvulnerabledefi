# Side-entrance

```
function test_sideEntrance() public checkSolvedByPlayer {
        //pool.deposit{value:PLAYER_INITIAL_ETH_BALANCE}();
        Attack attack = new Attack();
        attack.makeLoan(address(pool));
        attack.withdraw(recovery);
    }
```