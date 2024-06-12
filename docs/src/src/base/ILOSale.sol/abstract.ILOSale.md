# ILOSale
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/be1379a5058f6506f3a229427893748ee4e5ab65/src/base/ILOSale.sol)

**Inherits:**
[IILOSale](/src/interfaces/IILOSale.sol/interface.IILOSale.md)


## State Variables
### saleInfo

```solidity
SaleInfo saleInfo;
```


## Functions
### buy

this function is for investor buying ILO


```solidity
function buy(uint256 raiseAmount, address recipient)
    external
    virtual
    override
    returns (uint256 tokenId, uint128 liquidity, uint256 amountAdded0, uint256 amountAdded1);
```

### beforeSale


```solidity
modifier beforeSale();
```

### afterSale


```solidity
modifier afterSale();
```

### duringSale


```solidity
modifier duringSale();
```

