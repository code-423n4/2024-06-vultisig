# PoolTicksCounter
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/be1379a5058f6506f3a229427893748ee4e5ab65/src/libraries/PoolTicksCounter.sol)


## Functions
### countInitializedTicksCrossed

*This function counts the number of initialized ticks that would incur a gas cost between tickBefore and tickAfter.
When tickBefore and/or tickAfter themselves are initialized, the logic over whether we should count them depends on the
direction of the swap. If we are swapping upwards (tickAfter > tickBefore) we don't want to count tickBefore but we do
want to count tickAfter. The opposite is true if we are swapping downwards.*


```solidity
function countInitializedTicksCrossed(IUniswapV3Pool self, int24 tickBefore, int24 tickAfter)
    internal
    view
    returns (uint32 initializedTicksCrossed);
```

### countOneBits


```solidity
function countOneBits(uint256 x) private pure returns (uint16);
```

