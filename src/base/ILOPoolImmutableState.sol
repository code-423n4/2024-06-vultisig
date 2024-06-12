// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;

import '../interfaces/IILOPoolImmutableState.sol';
import '../libraries/PoolAddress.sol';

/// @title Immutable state
/// @notice Immutable state used by periphery contracts
abstract contract ILOPoolImmutableState is IILOPoolImmutableState {
    /// @inheritdoc IILOPoolImmutableState
    address public override WETH9;

    uint16 constant BPS = 10000;
    address public override MANAGER;
    address public override RAISE_TOKEN;
    address public override SALE_TOKEN;
    int24 public override TICK_LOWER;
    int24 public override TICK_UPPER;
    uint160 public override SQRT_RATIO_X96;
    uint160 internal SQRT_RATIO_LOWER_X96;
    uint160 internal SQRT_RATIO_UPPER_X96;

    PoolAddress.PoolKey internal _cachedPoolKey;
    address internal _cachedUniV3PoolAddress;
}
