# CallbackValidation
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/a3fc4c57db039cc1b79c7925531b021576d1b1a7/src/libraries/CallbackValidation.sol)

Provides validation for callbacks from Uniswap V3 Pools


## Functions
### verifyCallback

Returns the address of a valid Uniswap V3 Pool


```solidity
function verifyCallback(address factory, address tokenA, address tokenB, uint24 fee)
    internal
    view
    returns (IUniswapV3Pool pool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`factory`|`address`|The contract address of the Uniswap V3 factory|
|`tokenA`|`address`|The contract address of either token0 or token1|
|`tokenB`|`address`|The contract address of the other token|
|`fee`|`uint24`|The fee collected upon every swap in the pool, denominated in hundredths of a bip|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`pool`|`IUniswapV3Pool`|The V3 pool contract address|


### verifyCallback

Returns the address of a valid Uniswap V3 Pool


```solidity
function verifyCallback(address factory, PoolAddress.PoolKey memory poolKey)
    internal
    view
    returns (IUniswapV3Pool pool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`factory`|`address`|The contract address of the Uniswap V3 factory|
|`poolKey`|`PoolAddress.PoolKey`|The identifying key of the V3 pool|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`pool`|`IUniswapV3Pool`|The V3 pool contract address|


