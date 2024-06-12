// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol';
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';
import '@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3MintCallback.sol';

import '../libraries/PoolAddress.sol';
import '../libraries/LiquidityAmounts.sol';

import './PeripheryPayments.sol';
import './ILOPoolImmutableState.sol';

/// @title Liquidity management functions
/// @notice Internal functions for safely managing liquidity in Uniswap V3
abstract contract LiquidityManagement is IUniswapV3MintCallback, ILOPoolImmutableState, PeripheryPayments {
    /// @inheritdoc IUniswapV3MintCallback
    /// @dev as we modified nfpm, user dont need to pay at this step. so data is empty
    function uniswapV3MintCallback(
        uint256 amount0Owed,
        uint256 amount1Owed,
        bytes calldata data
    ) external override {
        require(msg.sender == _cachedUniV3PoolAddress);

        if (amount0Owed > 0) pay(_cachedPoolKey.token0, address(this), msg.sender, amount0Owed);
        if (amount1Owed > 0) pay(_cachedPoolKey.token1, address(this), msg.sender, amount1Owed);
    }

    struct AddLiquidityParams {
        IUniswapV3Pool pool;
        uint128 liquidity;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
    }

    /// @notice Add liquidity to an initialized pool
    function addLiquidity(AddLiquidityParams memory params)
        internal
        returns (
            uint256 amount0,
            uint256 amount1
        )
    {
        (amount0, amount1) = params.pool.mint(
            address(this),
            TICK_LOWER,
            TICK_UPPER,
            params.liquidity,
            ""
        );

        require(amount0 >= params.amount0Min && amount1 >= params.amount1Min, 'Price slippage check');
    }
}
