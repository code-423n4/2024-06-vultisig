# IILOVest
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/interfaces/IILOVest.sol)


## Functions
### vestingStatus

return vesting status of position


```solidity
function vestingStatus(uint256 tokenId) external returns (uint128 unlockedLiquidity, uint128 claimedLiquidity);
```

## Structs
### VestingConfig

```solidity
struct VestingConfig {
    uint16 shares;
    address recipient;
    LinearVest[] schedule;
}
```

### LinearVest

```solidity
struct LinearVest {
    uint16 shares;
    uint64 start;
    uint64 end;
}
```

### PositionVest

```solidity
struct PositionVest {
    uint128 totalLiquidity;
    LinearVest[] schedule;
}
```

