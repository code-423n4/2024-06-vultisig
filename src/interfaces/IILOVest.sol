// SPDX-License-Identifier: BUSL-1.1 
pragma solidity =0.7.6;
pragma abicoder v2;

interface IILOVest {
    struct VestingConfig {
        uint16 shares; // BPS shares
        address recipient;
        LinearVest[] schedule;
    }

    struct LinearVest {
        uint16 shares; // vesting shares in total liquidity (in BPS)
        uint64 start;
        uint64 end;
    }

    struct PositionVest {
        uint128 totalLiquidity;
        LinearVest[] schedule;
    }

    /// @notice return vesting status of position
    function vestingStatus(uint256 tokenId) external returns (
        uint128 unlockedLiquidity,
        uint128 claimedLiquidity
    );
}