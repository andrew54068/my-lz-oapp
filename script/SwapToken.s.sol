// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "forge-std/Script.sol";
import { StargateOApp } from "../contracts/StargateOApp.sol";
import { OptionsBuilder } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";
import { MessagingFee } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol";
import { MessagingReceipt } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppSender.sol";
import { SendParam } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/interfaces/IOFT.sol";
import { IStargate } from "@stargatefinance/stg-evm-v2/src/interfaces/IStargate.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SwapToken is Script {
    using OptionsBuilder for bytes;

    // Endpoint addresses
    address constant optimismSepoliaEndpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f;
    address constant arbitrumSepoliaEndpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f;

    address constant usdcArbitrumSepolia = 0x3253a335E7bFfB4790Aa4C25C4250d206E9b9773;
    address constant stargate = 0x0d7aB83370b492f2AB096c80111381674456e8d8; // StargatePoolUSDC Arbitrum Sepolia

    address composer = 0x89e20ef8ccdf9FC8D15Fb7E69fD9E0458C6ec00c; // ComposerReceiverAMM on Optimism Sepolia

    // OApp addresses
    address constant arbitrumOApp = 0xF1410D2d62dC28d1b977dA8e84FB743434988720;
    address constant optimismOApp = 0x7D8524950828398dD1d607FC764E79a89728112c;

    uint32 constant arbsep_v2_testnet = 40231;
    uint32 constant optsep_v2_testnet = 40232;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        StargateOApp stargateOApp = StargateOApp(payable(arbitrumOApp));

        address _tokenReceiver = optimismOApp;
        address _oftOnDestination = 0x5fd84259d66Cd46123540766Be93DFE6D43130D7; // USDC on Optimism
        uint256 _tokenOut = 100;
        uint256 _amountOutMinDest = 100;
    
        IERC20(usdcArbitrumSepolia).approve(stargate, _tokenOut);

        bytes memory _composeMsg = abi.encode(_tokenReceiver, _oftOnDestination, _tokenOut, _amountOutMinDest);

        (uint256 valueToSend, SendParam memory sendParam, MessagingFee memory messagingFee) = stargateOApp
            .prepareTakeTaxiAndAMMSwap(stargate, optsep_v2_testnet, _tokenOut, address(composer), _composeMsg);

        console.log(valueToSend);

        IStargate(stargate).sendToken{ value: valueToSend }(sendParam, messagingFee, msg.sender);

        vm.stopBroadcast();
    }
}
