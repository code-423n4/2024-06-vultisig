# PathTest
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/test/PathTest.sol)


## Functions
### hasMultiplePools


```solidity
function hasMultiplePools(bytes memory path) public pure returns (bool);
```

### decodeFirstPool


```solidity
function decodeFirstPool(bytes memory path) public pure returns (address tokenA, address tokenB, uint24 fee);
```

### getFirstPool


```solidity
function getFirstPool(bytes memory path) public pure returns (bytes memory);
```

### skipToken


```solidity
function skipToken(bytes memory path) public pure returns (bytes memory);
```

### getGasCostOfDecodeFirstPool


```solidity
function getGasCostOfDecodeFirstPool(bytes memory path) public view returns (uint256);
```

