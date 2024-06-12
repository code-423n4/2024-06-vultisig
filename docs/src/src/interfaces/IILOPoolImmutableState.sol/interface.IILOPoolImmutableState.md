# IILOPoolImmutableState
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/interfaces/IILOPoolImmutableState.sol)

Functions that return immutable state of the router


## Functions
### WETH9


```solidity
function WETH9() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|Returns the address of WETH9|


### MANAGER


```solidity
function MANAGER() external view returns (address);
```

### RAISE_TOKEN


```solidity
function RAISE_TOKEN() external view returns (address);
```

### SALE_TOKEN


```solidity
function SALE_TOKEN() external view returns (address);
```

### TICK_LOWER


```solidity
function TICK_LOWER() external view returns (int24);
```

### TICK_UPPER


```solidity
function TICK_UPPER() external view returns (int24);
```

### SQRT_RATIO_X96


```solidity
function SQRT_RATIO_X96() external view returns (uint160);
```

