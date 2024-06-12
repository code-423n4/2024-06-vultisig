// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Vultisig} from "../Vultisig.sol";
import {IWhitelist} from "../interfaces/IWhitelist.sol";

/**
 * @title Extended Vultisig token contract with whitelist contract interactions
 * @notice During whitelist period, `_beforeTokenTransfer` function will call `checkWhitelist` function of whitelist contract
 * @notice If whitelist period is ended, owner will set whitelist contract address back to address(0) and tokens will be transferred freely
 */
contract VultisigWhitelisted is Vultisig {
    /// @notice whitelist contract address
    address private _whitelistContract;

    /// @notice Returns current whitelist contract address
    function whitelistContract() external view returns (address) {
        return _whitelistContract;
    }

    /// @notice Ownable function to set new whitelist contract address
    function setWhitelistContract(address newWhitelistContract) external onlyOwner {
        _whitelistContract = newWhitelistContract;
    }

    /// @notice Before token transfer hook
    /// @dev It will call `checkWhitelist` function and if it's succsessful, it will transfer tokens, unless revert
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        if (_whitelistContract != address(0)) {
            IWhitelist(_whitelistContract).checkWhitelist(from, to, amount);
        }
        super._beforeTokenTransfer(from, to, amount);
    }
}
