// SPDX-License-Identifier: BUSL-1.1 

pragma solidity =0.7.6;

abstract contract Initializable {
    bool private _initialized;
    function _disableInitialize() internal {
        _initialized = true;
    }
    modifier whenNotInitialized() {
        require(!_initialized);
        _;
        _initialized = true;
    }
    modifier afterInitialize() {
        require(_initialized);
        _;
    }
}