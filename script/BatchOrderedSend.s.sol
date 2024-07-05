// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "forge-std/Script.sol";
import { MyOrderedOApp } from "../contracts/MyOrderedOApp.sol";
import { OptionsBuilder } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";
import { MessagingFee } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol";
import { MessagingReceipt } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppSender.sol";

contract SendBatchMessage is Script {
    using OptionsBuilder for bytes;

    // Endpoint addresses
    address constant optimismSepoliaEndpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f;
    address constant arbitrumSepoliaEndpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f;
    address constant amoyEndpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f;

    // OApp addresses
    address constant amoyOApp = 0x336FD68e735D4803F9AC3fC7D52B95C4Db0F278E;
    // address constant arbitrumOApp = 0x89e20ef8ccdf9FC8D15Fb7E69fD9E0458C6ec00c;
    address constant optimismOApp = 0xb0681A48b42b9941540fa1F4C1B7cC583587C2eA;

    // uint32 constant arbsep_v2_testnet = 40231;
    uint32 constant optsep_v2_testnet = 40232;
    uint32 constant amoy_v2_testnet = 40267;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MyOrderedOApp myOrderedOApp = MyOrderedOApp(payable(optimismOApp));

        uint128 gas_limit = 500000;
        uint128 msg_value = 10;
        uint256 nativeDrop = 1000;

        bytes memory _options = OptionsBuilder
            .newOptions()
            .addExecutorNativeDropOption(uint128(nativeDrop), bytes32(uint256(uint160(amoyOApp))))
            .addExecutorLzReceiveOption(gas_limit, msg_value)
            .addExecutorOrderedExecutionOption();

        string memory message1 = "This is an ordered test message1.";
        string memory message2 = "This is an ordered test message2.";

        uint32 destinationChain = amoy_v2_testnet;

        MessagingFee memory fee1 = myOrderedOApp.quote(destinationChain, message1, _options, false);
        MessagingFee memory fee2 = myOrderedOApp.quote(destinationChain, message2, _options, false);

        console.log("nativeFee fee1:", fee1.nativeFee, ", with lzTokenFee1:", fee1.lzTokenFee);
        console.log("nativeFee fee2:", fee2.nativeFee, ", with lzTokenFee2:", fee2.lzTokenFee);

        string[] memory messages = new string[](2);
        messages[0] = message1;
        messages[1] = message2;

        bytes[] memory options = new bytes[](2);
        options[0] = _options;
        options[1] = _options;

        uint256[] memory fees = new uint256[](2);
        fees[0] = fee1.nativeFee;
        fees[1] = fee2.nativeFee;

        MessagingReceipt[] memory receipts = myOrderedOApp.sendBatch{ value: fee1.nativeFee + fee2.nativeFee }(
            destinationChain,
            messages,
            options,
            fees
        );
        for (uint256 i = 0; i < receipts.length; i++) {
            bytes32 guid = receipts[i].guid;
            uint64 nonce = receipts[i].nonce;
            uint256 nativeFee = receipts[i].fee.nativeFee;
            uint256 lzTokenFee = receipts[i].fee.lzTokenFee;
            console.logBytes32(guid);
            console.logUint(nonce);
            console.logUint(nativeFee);
            console.logUint(lzTokenFee);
        }


        // MessagingReceipt memory receipt = myOrderedOApp.send{ value: fee1.nativeFee }(
        //     amoy_v2_testnet,
        //     message1,
        //     _options
        // );

        // bytes32 guid = receipt.guid;
        // uint64 nonce = receipt.nonce;
        // uint256 nativeFee = receipt.fee.nativeFee;
        // uint256 lzTokenFee = receipt.fee.lzTokenFee;
        // console.logBytes32(guid);
        // console.logUint(nonce);
        // console.logUint(nativeFee);
        // console.logUint(lzTokenFee);

        vm.stopBroadcast();
    }
}
