// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "forge-std/Script.sol";
import { MyOApp } from "../contracts/MyOApp.sol";
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
    address constant amoyOApp = 0x3E1506Ee1EBf9f3BF946a83e8e21b967e11F8963;
    address constant arbitrumOApp = 0xEBEBaA535eECC0De6B5467AcacC752708Cf3050B;

    uint32 constant arbsep_v2_testnet = 40231;
    uint32 constant optsep_v2_testnet = 40232;
    uint32 constant amoy_v2_testnet = 40267;

    function run(address payable sender) external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MyOApp myOApp = MyOApp(sender);

        // uint128 gas_limit = 85000;
        uint128 gas_limit = 50000;
        uint128 msg_value = 0;

        bytes memory _options = OptionsBuilder.newOptions()
            .addExecutorNativeDropOption(100000, bytes32(uint256(uint160(amoyOApp)) << 96))
            .addExecutorLzReceiveOption(gas_limit, msg_value);

        string memory message = "Hello, LayerZero!";

        MessagingFee memory fee = myOApp.quote(amoy_v2_testnet, message, _options, false);

        console.log("nativeFee fee:", fee.nativeFee, ", with lzTokenFee:", fee.lzTokenFee);

        MessagingReceipt memory receipt = myOApp.send{ value: fee.nativeFee }(amoy_v2_testnet, message, _options);
        console.log("nativeFee fee:", fee.nativeFee, ", with lzTokenFee:", fee.lzTokenFee);
        bytes32 guid = receipt.guid;
        uint64 nonce = receipt.nonce;
        uint256 nativeFee = receipt.fee.nativeFee;
        uint256 lzTokenFee = receipt.fee.lzTokenFee;

        console.logBytes32(guid);
        console.logUint(nonce);
        console.logUint(nativeFee);
        console.logUint(lzTokenFee);

        vm.stopBroadcast();
    }
}
