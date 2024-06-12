# IILOPool
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/interfaces/IILOPool.sol)

**Inherits:**
[IILOVest](/src/interfaces/IILOVest.sol/interface.IILOVest.md), [IILOSale](/src/interfaces/IILOSale.sol/interface.IILOSale.md), [IPeripheryPayments](/src/interfaces/IPeripheryPayments.sol/interface.IPeripheryPayments.md), [IILOPoolImmutableState](/src/interfaces/IILOPoolImmutableState.sol/interface.IILOPoolImmutableState.md), IERC721Metadata, IERC721Enumerable

Wraps Uniswap V3 positions in a non-fungible token interface which allows for them to be transferred
and authorized.


## Functions
### positions

Returns the position information associated with a given token ID.

*Throws if the token ID is not valid.*


```solidity
function positions(uint256 tokenId)
    external
    view
    returns (uint128 liquidity, uint256 raiseAmount, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|The ID of the token that represents the position|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`liquidity`|`uint128`|The liquidity of the position|
|`raiseAmount`|`uint256`|The raise amount of the position|
|`feeGrowthInside0LastX128`|`uint256`|The fee growth of token0 as of the last action on the individual position|
|`feeGrowthInside1LastX128`|`uint256`|The fee growth of token1 as of the last action on the individual position|


### claim

Returns number of collected tokens associated with a given token ID.


```solidity
function claim(uint256 tokenId) external payable returns (uint256 amount0, uint256 amount1);
```

### initialize


```solidity
function initialize(InitPoolParams calldata initPoolParams) external;
```

### launch


```solidity
function launch() external;
```

### claimProjectRefund

project admin claim refund sale token


```solidity
function claimProjectRefund(address projectAdmin) external returns (uint256 refundAmount);
```

### claimRefund

user claim refund when refund conditions are met


```solidity
function claimRefund(uint256 tokenId) external;
```

## Events
### IncreaseLiquidity
Emitted when liquidity is increased for a position NFT

*Also emitted when a token is minted*


```solidity
event IncreaseLiquidity(uint256 indexed tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|The ID of the token for which liquidity was increased|
|`liquidity`|`uint128`|The amount by which liquidity for the NFT position was increased|
|`amount0`|`uint256`|The amount of token0 that was paid for the increase in liquidity|
|`amount1`|`uint256`|The amount of token1 that was paid for the increase in liquidity|

### DecreaseLiquidity
Emitted when liquidity is decreased for a position NFT


```solidity
event DecreaseLiquidity(uint256 indexed tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|The ID of the token for which liquidity was decreased|
|`liquidity`|`uint128`|The amount by which liquidity for the NFT position was decreased|
|`amount0`|`uint256`|The amount of token0 that was accounted for the decrease in liquidity|
|`amount1`|`uint256`|The amount of token1 that was accounted for the decrease in liquidity|

### Collect
Emitted when tokens are collected for a position NFT

*The amounts reported may not be exactly equivalent to the amounts transferred, due to rounding behavior*


```solidity
event Collect(uint256 indexed tokenId, address recipient, uint256 amount0, uint256 amount1);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|The ID of the token for which underlying tokens were collected|
|`recipient`|`address`|The address of the account that received the collected tokens|
|`amount0`|`uint256`|The amount of token0 owed to the position that was collected|
|`amount1`|`uint256`|The amount of token1 owed to the position that was collected|

### ILOPoolInitialized

```solidity
event ILOPoolInitialized(
    address indexed univ3Pool, int32 tickLower, int32 tickUpper, SaleInfo saleInfo, VestingConfig[] vestingConfig
);
```

### Claim

```solidity
event Claim(
    address indexed user,
    uint256 tokenId,
    uint128 liquidity,
    uint256 amount0,
    uint256 amount1,
    uint256 feeGrowthInside0LastX128,
    uint256 feeGrowthInside1LastX128
);
```

### Buy

```solidity
event Buy(address indexed investor, uint256 tokenId, uint256 raiseAmount, uint128 liquidity);
```

### PoolLaunch

```solidity
event PoolLaunch(address indexed project, uint128 liquidity, uint256 token0, uint256 token1);
```

### UserRefund

```solidity
event UserRefund(address indexed user, uint256 tokenId, uint256 raiseTokenAmount);
```

### ProjectRefund

```solidity
event ProjectRefund(address indexed projectAdmin, uint256 saleTokenAmount);
```

## Structs
### Position

```solidity
struct Position {
    uint128 liquidity;
    uint256 feeGrowthInside0LastX128;
    uint256 feeGrowthInside1LastX128;
    uint256 raiseAmount;
}
```

### InitPoolParams

```solidity
struct InitPoolParams {
    address uniV3Pool;
    int24 tickLower;
    int24 tickUpper;
    uint160 sqrtRatioLowerX96;
    uint160 sqrtRatioUpperX96;
    uint256 hardCap;
    uint256 softCap;
    uint256 maxCapPerUser;
    uint64 start;
    uint64 end;
    VestingConfig[] vestingConfigs;
}
```

