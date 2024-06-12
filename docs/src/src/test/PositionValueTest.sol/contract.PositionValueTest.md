# PositionValueTest
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/test/PositionValueTest.sol)


## Functions
### total


```solidity
function total(IILOPool nft, uint256 tokenId, uint160 sqrtRatioX96)
    external
    view
    returns (uint256 amount0, uint256 amount1);
```

### principal


```solidity
function principal(IILOPool nft, uint256 tokenId, uint160 sqrtRatioX96)
    external
    view
    returns (uint256 amount0, uint256 amount1);
```

### fees


```solidity
function fees(IILOPool nft, uint256 tokenId) external view returns (uint256 amount0, uint256 amount1);
```

### totalGas


```solidity
function totalGas(IILOPool nft, uint256 tokenId, uint160 sqrtRatioX96) external view returns (uint256);
```

### principalGas


```solidity
function principalGas(IILOPool nft, uint256 tokenId, uint160 sqrtRatioX96) external view returns (uint256);
```

### feesGas


```solidity
function feesGas(IILOPool nft, uint256 tokenId) external view returns (uint256);
```

