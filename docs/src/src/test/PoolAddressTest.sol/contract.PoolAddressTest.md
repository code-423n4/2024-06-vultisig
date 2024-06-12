# PoolAddressTest
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/test/PoolAddressTest.sol)


## Functions
### POOL_INIT_CODE_HASH


```solidity
function POOL_INIT_CODE_HASH() external pure returns (bytes32);
```

### computeAddress


```solidity
function computeAddress(address factory, address token0, address token1, uint24 fee) external pure returns (address);
```

### getGasCostOfComputeAddress


```solidity
function getGasCostOfComputeAddress(address factory, address token0, address token1, uint24 fee)
    external
    view
    returns (uint256);
```

