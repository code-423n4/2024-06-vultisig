# ILOPoolImmutableState
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/base/ILOPoolImmutableState.sol)

**Inherits:**
[IILOPoolImmutableState](/src/interfaces/IILOPoolImmutableState.sol/interface.IILOPoolImmutableState.md)

Immutable state used by periphery contracts


## State Variables
### WETH9

```solidity
address public override WETH9;
```


### BPS

```solidity
uint16 constant BPS = 10000;
```


### MANAGER

```solidity
address public override MANAGER;
```


### RAISE_TOKEN

```solidity
address public override RAISE_TOKEN;
```


### SALE_TOKEN

```solidity
address public override SALE_TOKEN;
```


### TICK_LOWER

```solidity
int24 public override TICK_LOWER;
```


### TICK_UPPER

```solidity
int24 public override TICK_UPPER;
```


### SQRT_RATIO_X96

```solidity
uint160 public override SQRT_RATIO_X96;
```


### SQRT_RATIO_LOWER_X96

```solidity
uint160 internal SQRT_RATIO_LOWER_X96;
```


### SQRT_RATIO_UPPER_X96

```solidity
uint160 internal SQRT_RATIO_UPPER_X96;
```


### _cachedPoolKey

```solidity
PoolAddress.PoolKey internal _cachedPoolKey;
```


### _cachedUniV3PoolAddress

```solidity
address internal _cachedUniV3PoolAddress;
```


