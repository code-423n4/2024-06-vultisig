# TestMulticall
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/test/TestMulticall.sol)

**Inherits:**
[Multicall](/src/base/Multicall.sol/abstract.Multicall.md)


## State Variables
### paid

```solidity
uint256 public paid;
```


## Functions
### functionThatRevertsWithError


```solidity
function functionThatRevertsWithError(string memory error) external pure;
```

### functionThatReturnsTuple


```solidity
function functionThatReturnsTuple(uint256 a, uint256 b) external pure returns (Tuple memory tuple);
```

### pays


```solidity
function pays() external payable;
```

### returnSender


```solidity
function returnSender() external view returns (address);
```

## Structs
### Tuple

```solidity
struct Tuple {
    uint256 a;
    uint256 b;
}
```

