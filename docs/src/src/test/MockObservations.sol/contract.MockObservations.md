# MockObservations
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/test/MockObservations.sol)


## State Variables
### oracleObservations

```solidity
Oracle.Observation[4] internal oracleObservations;
```


### slot0Tick

```solidity
int24 slot0Tick;
```


### slot0ObservationCardinality

```solidity
uint16 internal slot0ObservationCardinality;
```


### slot0ObservationIndex

```solidity
uint16 internal slot0ObservationIndex;
```


### liquidity

```solidity
uint128 public liquidity;
```


### lastObservationCurrentTimestamp

```solidity
bool internal lastObservationCurrentTimestamp;
```


## Functions
### constructor


```solidity
constructor(
    uint32[4] memory _blockTimestamps,
    int56[4] memory _tickCumulatives,
    uint128[4] memory _secondsPerLiquidityCumulativeX128s,
    bool[4] memory _initializeds,
    int24 _tick,
    uint16 _observationCardinality,
    uint16 _observationIndex,
    bool _lastObservationCurrentTimestamp,
    uint128 _liquidity
);
```

### slot0


```solidity
function slot0() external view returns (uint160, int24, uint16, uint16, uint16, uint8, bool);
```

### observations


```solidity
function observations(uint256 index) external view returns (uint32, int56, uint160, bool);
```

