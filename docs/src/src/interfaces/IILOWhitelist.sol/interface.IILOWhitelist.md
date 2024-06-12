# IILOWhitelist
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/interfaces/IILOWhitelist.sol)


## Functions
### setOpenToAll


```solidity
function setOpenToAll(bool openToAll) external;
```

### isOpenToAll


```solidity
function isOpenToAll() external returns (bool);
```

### isWhitelisted


```solidity
function isWhitelisted(address user) external returns (bool);
```

### batchWhitelist


```solidity
function batchWhitelist(address[] calldata users) external;
```

### batchRemoveWhitelist


```solidity
function batchRemoveWhitelist(address[] calldata users) external;
```

### onlyProjectAdmin


```solidity
modifier onlyProjectAdmin() virtual;
```

## Events
### SetWhitelist

```solidity
event SetWhitelist(address indexed user, bool isWhitelist);
```

### SetOpenToAll

```solidity
event SetOpenToAll(bool openToAll);
```

