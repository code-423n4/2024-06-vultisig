# IILOSale
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/interfaces/IILOSale.sol)


## Functions
### buy

this function is for investor buying ILO


```solidity
function buy(uint256 raiseAmount, address recipient) external returns (uint256 tokenId, uint128 liquidity);
```

### totalSold

returns amount of sale token that has already been sold

*sale token amount is rounded up*


```solidity
function totalSold() external view returns (uint256);
```

## Structs
### SaleInfo

```solidity
struct SaleInfo {
    uint256 hardCap;
    uint256 softCap;
    uint256 maxCapPerUser;
    uint64 start;
    uint64 end;
    uint256 maxSaleAmount;
}
```

