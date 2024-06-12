// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

/// @title Immutable state
/// @notice Functions that return immutable state of the router
interface IILOPoolImmutableState {
    /// @return Returns the address of WETH9
    function WETH9() external view returns (address);

    function MANAGER() external view returns (address);
    function RAISE_TOKEN() external view returns (address);
    function SALE_TOKEN() external view returns (address);
    function TICK_LOWER() external view returns (int24);
    function TICK_UPPER() external view returns (int24);
    function SQRT_RATIO_X96() external view returns (uint160);
}
