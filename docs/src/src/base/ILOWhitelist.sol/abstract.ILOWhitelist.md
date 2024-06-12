# ILOWhitelist
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/base/ILOWhitelist.sol)

**Inherits:**
[IILOWhitelist](/src/interfaces/IILOWhitelist.sol/interface.IILOWhitelist.md)


## State Variables
### _openToAll

```solidity
bool private _openToAll;
```


### _whitelisted

```solidity
EnumerableSet.AddressSet private _whitelisted;
```


## Functions
### setOpenToAll


```solidity
function setOpenToAll(bool openToAll) external override onlyProjectAdmin;
```

### isOpenToAll


```solidity
function isOpenToAll() external view override returns (bool);
```

### isWhitelisted


```solidity
function isWhitelisted(address user) external view override returns (bool);
```

### batchWhitelist


```solidity
function batchWhitelist(address[] calldata users) external override onlyProjectAdmin;
```

### batchRemoveWhitelist


```solidity
function batchRemoveWhitelist(address[] calldata users) external override onlyProjectAdmin;
```

### _setOpenToAll


```solidity
function _setOpenToAll(bool openToAll) internal;
```

### _removeWhitelist


```solidity
function _removeWhitelist(address user) internal;
```

### _setWhitelist


```solidity
function _setWhitelist(address user) internal;
```

### _isWhitelisted


```solidity
function _isWhitelisted(address user) internal view returns (bool);
```

