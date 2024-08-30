# Puppet
```
function test_puppet() public checkSolvedByPlayer {
        Puppet puppet = new Puppet{value:PLAYER_INITIAL_ETH_BALANCE}(uniswapV1Exchange, token, lendingPool);
        token.transfer(address(puppet), PLAYER_INITIAL_TOKEN_BALANCE);
        puppet.attack(recovery);
    }
```