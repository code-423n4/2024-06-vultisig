# IPoolInitializer
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/a3fc4c57db039cc1b79c7925531b021576d1b1a7/src/interfaces/IPoolInitializer.sol)

Provides a method for creating and initializing a pool, if necessary, for bundling with other methods that
require the pool to exist.


## Functions
### createAndInitializePoolIfNecessary

Creates a new pool if it does not exist, then initializes if not initialized

*This method can be bundled with others via IMulticall for the first action (e.g. mint) performed against a pool*


```solidity
function createAndInitializePoolIfNecessary(address token0, address token1, uint24 fee, uint160 sqrtPriceX96)
    external
    payable
    returns (address pool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token0`|`address`|The contract address of token0 of the pool|
|`token1`|`address`|The contract address of token1 of the pool|
|`fee`|`uint24`|The fee amount of the v3 pool for the specified token pair|
|`sqrtPriceX96`|`uint160`|The initial square root price of the pool as a Q64.96 value|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`pool`|`address`|Returns the pool address based on the pair of tokens and fee, will return the newly created pool address if necessary|


