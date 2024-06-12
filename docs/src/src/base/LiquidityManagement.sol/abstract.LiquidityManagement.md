# LiquidityManagement
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/base/LiquidityManagement.sol)

**Inherits:**
IUniswapV3MintCallback, [ILOPoolImmutableState](/src/base/ILOPoolImmutableState.sol/abstract.ILOPoolImmutableState.md), [PeripheryPayments](/src/base/PeripheryPayments.sol/abstract.PeripheryPayments.md)

Internal functions for safely managing liquidity in Uniswap V3


## Functions
### uniswapV3MintCallback

Called to `msg.sender` after minting liquidity to a position from IUniswapV3Pool#mint.

*as we modified nfpm, user dont need to pay at this step. so data is empty*


```solidity
function uniswapV3MintCallback(uint256 amount0Owed, uint256 amount1Owed, bytes calldata data) external override;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`amount0Owed`|`uint256`|The amount of token0 due to the pool for the minted liquidity|
|`amount1Owed`|`uint256`|The amount of token1 due to the pool for the minted liquidity|
|`data`|`bytes`|Any data passed through by the caller via the IUniswapV3PoolActions#mint call|


### addLiquidity

Add liquidity to an initialized pool


```solidity
function addLiquidity(AddLiquidityParams memory params) internal returns (uint256 amount0, uint256 amount1);
```

## Structs
### AddLiquidityParams

```solidity
struct AddLiquidityParams {
    IUniswapV3Pool pool;
    uint128 liquidity;
    uint256 amount0Desired;
    uint256 amount1Desired;
    uint256 amount0Min;
    uint256 amount1Min;
}
```

