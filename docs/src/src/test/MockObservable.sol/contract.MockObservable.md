# MockObservable
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/test/MockObservable.sol)


## State Variables
### observation0

```solidity
Observation private observation0;
```


### observation1

```solidity
Observation private observation1;
```


## Functions
### constructor


```solidity
constructor(
    uint32[] memory secondsAgos,
    int56[] memory tickCumulatives,
    uint160[] memory secondsPerLiquidityCumulativeX128s
);
```

### observe


```solidity
function observe(uint32[] calldata secondsAgos)
    external
    view
    returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
```

## Structs
### Observation

```solidity
struct Observation {
    uint32 secondsAgo;
    int56 tickCumulatives;
    uint160 secondsPerLiquidityCumulativeX128s;
}
```

