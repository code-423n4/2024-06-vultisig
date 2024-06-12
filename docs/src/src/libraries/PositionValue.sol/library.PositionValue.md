# PositionValue
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/libraries/PositionValue.sol)


## Functions
### total

Returns the total amounts of token0 and token1, i.e. the sum of fees and principal
that a given nonfungible position manager token is worth


```solidity
function total(IILOPool positionManager, uint256 tokenId, uint160 sqrtRatioX96)
    internal
    view
    returns (uint256 amount0, uint256 amount1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`positionManager`|`IILOPool`|The ILOPool|
|`tokenId`|`uint256`|The tokenId of the token for which to get the total value|
|`sqrtRatioX96`|`uint160`|The square root price X96 for which to calculate the principal amounts|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amount0`|`uint256`|The total amount of token0 including principal and fees|
|`amount1`|`uint256`|The total amount of token1 including principal and fees|


### principal

Calculates the principal (currently acting as liquidity) owed to the token owner in the event
that the position is burned


```solidity
function principal(IILOPool positionManager, uint256 tokenId, uint160 sqrtRatioX96)
    internal
    view
    returns (uint256 amount0, uint256 amount1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`positionManager`|`IILOPool`|The ILOPool|
|`tokenId`|`uint256`|The tokenId of the token for which to get the total principal owed|
|`sqrtRatioX96`|`uint160`|The square root price X96 for which to calculate the principal amounts|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amount0`|`uint256`|The principal amount of token0|
|`amount1`|`uint256`|The principal amount of token1|


### fees

Calculates the total fees owed to the token owner


```solidity
function fees(IILOPool positionManager, uint256 tokenId) internal view returns (uint256 amount0, uint256 amount1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`positionManager`|`IILOPool`|The ILOPool|
|`tokenId`|`uint256`|The tokenId of the token for which to get the total fees owed|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amount0`|`uint256`|The amount of fees owed in token0|
|`amount1`|`uint256`|The amount of fees owed in token1|


### _fees


```solidity
function _fees(IILOPool positionManager, FeeParams memory feeParams)
    private
    view
    returns (uint256 amount0, uint256 amount1);
```

### _getFeeGrowthInside


```solidity
function _getFeeGrowthInside(IUniswapV3Pool pool, int24 tickLower, int24 tickUpper)
    private
    view
    returns (uint256 feeGrowthInside0X128, uint256 feeGrowthInside1X128);
```

## Structs
### FeeParams

```solidity
struct FeeParams {
    address token0;
    address token1;
    uint24 fee;
    int24 tickLower;
    int24 tickUpper;
    uint128 liquidity;
    uint256 positionFeeGrowthInside0LastX128;
    uint256 positionFeeGrowthInside1LastX128;
    uint256 tokensOwed0;
    uint256 tokensOwed1;
}
```

