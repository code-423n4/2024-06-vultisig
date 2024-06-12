# MockTimeILOPool
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/test/MockTimeILOPool.sol)

**Inherits:**
[ILOPool](/src/ILOPool.sol/contract.ILOPool.md)


## State Variables
### time

```solidity
uint256 time;
```


## Functions
### constructor


```solidity
constructor(address _factory, address _WETH9) ILOPool(_factory, _WETH9);
```

### _blockTimestamp


```solidity
function _blockTimestamp() internal view override returns (uint256);
```

### setTime


```solidity
function setTime(uint256 _time) external;
```

