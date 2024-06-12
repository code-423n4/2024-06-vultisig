// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IApproveAndCallReceiver} from "./interfaces/IApproveAndCallReceiver.sol";

/**
 * @title ERC20 based Vultisig token contract
 */
contract Vultisig is ERC20, Ownable {
    constructor() ERC20("Vultisig Token", "VULT") {
        _mint(_msgSender(), 100_000_000 * 1e18);
    }

    function approveAndCall(address spender, uint256 amount, bytes calldata extraData) external returns (bool) {
        // Approve the spender to spend the tokens
        _approve(msg.sender, spender, amount);

        // Call the receiveApproval function on the spender contract
        IApproveAndCallReceiver(spender).receiveApproval(msg.sender, amount, address(this), extraData);

        return true;
    }
}
