// SPDX-License-Identifier: BUSL-1.1 

pragma solidity =0.7.6;

import '@openzeppelin/contracts/utils/EnumerableSet.sol';
import '../interfaces/IILOWhitelist.sol';

abstract contract ILOWhitelist is IILOWhitelist {
    bool private _openToAll;

    /// @inheritdoc IILOWhitelist
    function setOpenToAll(bool openToAll) external override onlyProjectAdmin{
        _setOpenToAll(openToAll);
    }

    /// @inheritdoc IILOWhitelist
    function isOpenToAll() external override view returns(bool) {
        return _openToAll;
    }

    /// @inheritdoc IILOWhitelist
    function isWhitelisted(address user) external override view returns (bool) {
        return _isWhitelisted(user);
    }

    /// @inheritdoc IILOWhitelist
    function batchWhitelist(address[] calldata users) external override onlyProjectAdmin{
        for (uint256 i = 0; i < users.length; i++) {
            _setWhitelist(users[i]);
        }
    }

    /// @inheritdoc IILOWhitelist
    function batchRemoveWhitelist(address[] calldata users) external override onlyProjectAdmin{
        for (uint256 i = 0; i < users.length; i++) {
            _removeWhitelist(users[i]);
        }
    }

    EnumerableSet.AddressSet private _whitelisted;

    function _setOpenToAll(bool openToAll) internal {
        _openToAll = openToAll;
        emit SetOpenToAll(openToAll);
    }

    function _removeWhitelist(address user) internal {
        EnumerableSet.remove(_whitelisted, user);
        emit SetWhitelist(user, false);
    }

    function _setWhitelist(address user) internal {
        EnumerableSet.add(_whitelisted, user);
        emit SetWhitelist(user, true);
    }

    function _isWhitelisted(address user) internal view returns(bool) {
        return _openToAll || EnumerableSet.contains(_whitelisted, user);
    }
}
