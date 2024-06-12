# TestUniswapV3Callee
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/test/TestUniswapV3Callee.sol)

**Inherits:**
IUniswapV3SwapCallback


## Functions
### swapExact0For1


```solidity
function swapExact0For1(address pool, uint256 amount0In, address recipient, uint160 sqrtPriceLimitX96) external;
```

### swap0ForExact1


```solidity
function swap0ForExact1(address pool, uint256 amount1Out, address recipient, uint160 sqrtPriceLimitX96) external;
```

### swapExact1For0


```solidity
function swapExact1For0(address pool, uint256 amount1In, address recipient, uint160 sqrtPriceLimitX96) external;
```

### swap1ForExact0


```solidity
function swap1ForExact0(address pool, uint256 amount0Out, address recipient, uint160 sqrtPriceLimitX96) external;
```

### uniswapV3SwapCallback


```solidity
function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external override;
```

