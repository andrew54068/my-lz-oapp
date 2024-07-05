// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ILayerZeroComposer } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroComposer.sol";
import { OFTComposeMsgCodec } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/libs/OFTComposeMsgCodec.sol";

contract ComposerReceiverAMM is ILayerZeroComposer {
    // IMockAMM public immutable amm;
    address public immutable endpoint;
    address public immutable stargate;

    event ReceivedOnDestination(address token);
    event SwapParam(address _tokenReceiver, address _oftOnDestination, address _tokenOut, uint _amountOutMinDest);

    constructor(address _endpoint, address _stargate) {
        endpoint = _endpoint;
        stargate = _stargate;
    }

    function lzCompose(
        address _from,
        bytes32 _guid,
        bytes calldata _message,
        address _executor,
        bytes calldata _extraData
    ) external payable {
        require(_from == stargate, "!stargate");
        require(msg.sender == endpoint, "!endpoint");

        uint256 amountLD = OFTComposeMsgCodec.amountLD(_message);
        bytes memory _composeMessage = OFTComposeMsgCodec.composeMsg(_message);

        (address _tokenReceiver, address _oftOnDestination, address _tokenOut, uint _amountOutMinDest) =
            abi.decode(_composeMessage, (address, address, address, uint));

        address[] memory path = new address[](2);
        path[0] = _oftOnDestination;
        path[1] = _tokenOut;

        emit SwapParam(_tokenReceiver, _oftOnDestination, _tokenOut, _amountOutMinDest);

        // IERC20(_oftOnDestination).approve(address(amm), amountLD);

        // try amm.swapExactTokensForTokens(
        //     amountLD,
        //     _amountOutMinDest,
        //     path,  
        //     _tokenReceiver, 
        //     _deadline 
        // ) {
        //     emit ReceivedOnDestination(_tokenOut);
        // } catch {
        //     IERC20(_oftOnDestination).transfer(_tokenReceiver, amountLD);
        //     emit ReceivedOnDestination(_oftOnDestination);
        // }
    }

    fallback() external payable {}
    receive() external payable {}
}