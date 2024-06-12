# SqrtPriceMathPartial
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/libraries/SqrtPriceMathPartial.sol)

Exposes two functions from @uniswap/v3-core SqrtPriceMath
that use square root of price as a Q64.96 and liquidity to compute deltas


## Functions
### getAmount0Delta

Gets the amount0 delta between two prices

*Calculates liquidity / sqrt(lower) - liquidity / sqrt(upper),
i.e. liquidity * (sqrt(upper) - sqrt(lower)) / (sqrt(upper) * sqrt(lower))*


```solidity
function getAmount0Delta(uint160 sqrtRatioAX96, uint160 sqrtRatioBX96, uint128 liquidity, bool roundUp)
    internal
    pure
    returns (uint256 amount0);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`sqrtRatioAX96`|`uint160`|A sqrt price|
|`sqrtRatioBX96`|`uint160`|Another sqrt price|
|`liquidity`|`uint128`|The amount of usable liquidity|
|`roundUp`|`bool`|Whether to round the amount up or down|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amount0`|`uint256`|Amount of token0 required to cover a position of size liquidity between the two passed prices|


### getAmount1Delta

Gets the amount1 delta between two prices

*Calculates liquidity * (sqrt(upper) - sqrt(lower))*


```solidity
function getAmount1Delta(uint160 sqrtRatioAX96, uint160 sqrtRatioBX96, uint128 liquidity, bool roundUp)
    internal
    pure
    returns (uint256 amount1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`sqrtRatioAX96`|`uint160`|A sqrt price|
|`sqrtRatioBX96`|`uint160`|Another sqrt price|
|`liquidity`|`uint128`|The amount of usable liquidity|
|`roundUp`|`bool`|Whether to round the amount up, or down|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amount1`|`uint256`|Amount of token1 required to cover a position of size liquidity between the two passed prices|


