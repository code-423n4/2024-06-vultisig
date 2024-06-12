// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IApproveAndCallReceiver} from "../interfaces/IApproveAndCallReceiver.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ApprovalReceiver is IApproveAndCallReceiver {
    event ApprovalReceived(address from, uint256 amount, address token, bytes extraData);

    function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external override {
        // Handle the approval logic
        emit ApprovalReceived(from, amount, token, extraData);

        // Transfer the approved tokens to this contract
        IERC20(token).transferFrom(from, address(this), amount);
        // Further logic using `extraData` can be implemented here
    }
}
