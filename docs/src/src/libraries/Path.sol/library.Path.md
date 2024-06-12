# Path
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/be1379a5058f6506f3a229427893748ee4e5ab65/src/libraries/Path.sol)


## State Variables
### ADDR_SIZE
*The length of the bytes encoded address*


```solidity
uint256 private constant ADDR_SIZE = 20;
```


### FEE_SIZE
*The length of the bytes encoded fee*


```solidity
uint256 private constant FEE_SIZE = 3;
```


### NEXT_OFFSET
*The offset of a single token address and pool fee*


```solidity
uint256 private constant NEXT_OFFSET = ADDR_SIZE + FEE_SIZE;
```


### POP_OFFSET
*The offset of an encoded pool key*


```solidity
uint256 private constant POP_OFFSET = NEXT_OFFSET + ADDR_SIZE;
```


### MULTIPLE_POOLS_MIN_LENGTH
*The minimum length of an encoding that contains 2 or more pools*


```solidity
uint256 private constant MULTIPLE_POOLS_MIN_LENGTH = POP_OFFSET + NEXT_OFFSET;
```


## Functions
### hasMultiplePools

Returns true iff the path contains two or more pools


```solidity
function hasMultiplePools(bytes memory path) internal pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`path`|`bytes`|The encoded swap path|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if path contains two or more pools, otherwise false|


### numPools

Returns the number of pools in the path


```solidity
function numPools(bytes memory path) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`path`|`bytes`|The encoded swap path|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The number of pools in the path|


### decodeFirstPool

Decodes the first pool in path


```solidity
function decodeFirstPool(bytes memory path) internal pure returns (address tokenA, address tokenB, uint24 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`path`|`bytes`|The bytes encoded swap path|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`tokenA`|`address`|The first token of the given pool|
|`tokenB`|`address`|The second token of the given pool|
|`fee`|`uint24`|The fee level of the pool|


### getFirstPool

Gets the segment corresponding to the first pool in the path


```solidity
function getFirstPool(bytes memory path) internal pure returns (bytes memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`path`|`bytes`|The bytes encoded swap path|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes`|The segment containing all data necessary to target the first pool in the path|


### skipToken

Skips a token + fee element from the buffer and returns the remainder


```solidity
function skipToken(bytes memory path) internal pure returns (bytes memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`path`|`bytes`|The swap path|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes`|The remaining token + fee elements in the path|


