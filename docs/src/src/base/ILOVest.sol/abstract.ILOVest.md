# ILOVest
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/base/ILOVest.sol)

**Inherits:**
[IILOVest](/src/interfaces/IILOVest.sol/interface.IILOVest.md)


## State Variables
### _positionVests

```solidity
mapping(uint256 => PositionVest) _positionVests;
```


## Functions
### _unlockedLiquidity

calculate amount of liquidity unlocked for claim


```solidity
function _unlockedLiquidity(uint256 tokenId) internal view virtual returns (uint128 liquidityUnlocked);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|nft token id of position|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`liquidityUnlocked`|`uint128`|amount of unlocked liquidity|


### _claimableLiquidity


```solidity
function _claimableLiquidity(uint256 tokenId) internal view virtual returns (uint128 claimableLiquidity);
```

### _validateSharesAndVests


```solidity
function _validateSharesAndVests(uint64 launchTime, VestingConfig[] memory vestingConfigs) internal pure;
```

### _validateVestSchedule


```solidity
function _validateVestSchedule(uint64 launchTime, LinearVest[] memory schedule) internal pure;
```

