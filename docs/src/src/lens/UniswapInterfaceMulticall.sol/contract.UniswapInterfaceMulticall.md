# UniswapInterfaceMulticall
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/be1379a5058f6506f3a229427893748ee4e5ab65/src/lens/UniswapInterfaceMulticall.sol)

A fork of Multicall2 specifically tailored for the Uniswap Interface


## Functions
### getCurrentBlockTimestamp


```solidity
function getCurrentBlockTimestamp() public view returns (uint256 timestamp);
```

### getEthBalance


```solidity
function getEthBalance(address addr) public view returns (uint256 balance);
```

### multicall


```solidity
function multicall(Call[] memory calls) public returns (uint256 blockNumber, Result[] memory returnData);
```

## Structs
### Call

```solidity
struct Call {
    address target;
    uint256 gasLimit;
    bytes callData;
}
```

### Result

```solidity
struct Result {
    bool success;
    uint256 gasUsed;
    bytes returnData;
}
```

