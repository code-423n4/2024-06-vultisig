# ILOPool
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/ILOPool.sol)

**Inherits:**
ERC721, [IILOPool](/src/interfaces/IILOPool.sol/interface.IILOPool.md), [ILOWhitelist](/src/base/ILOWhitelist.sol/abstract.ILOWhitelist.md), [ILOVest](/src/base/ILOVest.sol/abstract.ILOVest.md), [Initializable](/src/base/Initializable.sol/abstract.Initializable.md), [Multicall](/src/base/Multicall.sol/abstract.Multicall.md), [ILOPoolImmutableState](/src/base/ILOPoolImmutableState.sol/abstract.ILOPoolImmutableState.md), [LiquidityManagement](/src/base/LiquidityManagement.sol/abstract.LiquidityManagement.md)

Wraps Uniswap V3 positions in the ERC721 non-fungible token interface


## State Variables
### saleInfo

```solidity
SaleInfo saleInfo;
```


### _launchSucceeded
*when lauch successfully we can not refund anymore*


```solidity
bool private _launchSucceeded;
```


### _refundTriggered
*when refund triggered, we can not launch anymore*


```solidity
bool private _refundTriggered;
```


### _positions
*The token ID position data*


```solidity
mapping(uint256 => Position) private _positions;
```


### _vestingConfigs

```solidity
VestingConfig[] private _vestingConfigs;
```


### _nextId
*The ID of the next token that will be minted. Skips 0*


```solidity
uint256 private _nextId;
```


### totalRaised

```solidity
uint256 totalRaised;
```


## Functions
### constructor


```solidity
constructor() ERC721("", "");
```

### name


```solidity
function name() public pure override(ERC721, IERC721Metadata) returns (string memory);
```

### symbol


```solidity
function symbol() public pure override(ERC721, IERC721Metadata) returns (string memory);
```

### initialize


```solidity
function initialize(InitPoolParams calldata params) external override whenNotInitialized;
```

### positions

Returns the position information associated with a given token ID.

*Throws if the token ID is not valid.*


```solidity
function positions(uint256 tokenId)
    external
    view
    override
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


### buy

this function is for investor buying ILO


```solidity
function buy(uint256 raiseAmount, address recipient)
    external
    override
    returns (uint256 tokenId, uint128 liquidityDelta);
```

### isAuthorizedForToken


```solidity
modifier isAuthorizedForToken(uint256 tokenId);
```

### claim

Returns number of collected tokens associated with a given token ID.


```solidity
function claim(uint256 tokenId)
    external
    payable
    override
    isAuthorizedForToken(tokenId)
    returns (uint256 amount0, uint256 amount1);
```

### OnlyManager


```solidity
modifier OnlyManager();
```

### launch


```solidity
function launch() external override OnlyManager;
```

### refundable


```solidity
modifier refundable();
```

### claimRefund

user claim refund when refund conditions are met


```solidity
function claimRefund(uint256 tokenId) external override refundable isAuthorizedForToken(tokenId);
```

### claimProjectRefund

project admin claim refund sale token


```solidity
function claimProjectRefund(address projectAdmin)
    external
    override
    refundable
    OnlyManager
    returns (uint256 refundAmount);
```

### _refundProject


```solidity
function _refundProject(address projectAdmin) internal returns (uint256 refundAmount);
```

### totalSold

returns amount of sale token that has already been sold

*sale token amount is rounded up*


```solidity
function totalSold() public view override returns (uint256 _totalSold);
```

### _saleAmountNeeded

return sale token amount needed for the raiseAmount.

*sale token amount is rounded up*


```solidity
function _saleAmountNeeded(uint256 raiseAmount) internal view returns (uint256 saleAmountNeeded, uint128 liquidity);
```

### _unlockedLiquidity

calculate amount of liquidity unlocked for claim


```solidity
function _unlockedLiquidity(uint256 tokenId) internal view override returns (uint128 liquidityUnlocked);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|nft token id of position|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`liquidityUnlocked`|`uint128`|amount of unlocked liquidity|


### _deductFees

calculate the amount left after deduct fee


```solidity
function _deductFees(uint256 amount0, uint256 amount1, uint16 feeBPS)
    internal
    pure
    returns (uint256 amount0Left, uint256 amount1Left);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`amount0`|`uint256`|the amount of token0 before deduct fee|
|`amount1`|`uint256`|the amount of token1 before deduct fee|
|`feeBPS`|`uint16`||

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amount0Left`|`uint256`|the amount of token0 after deduct fee|
|`amount1Left`|`uint256`|the amount of token1 after deduct fee|


### vestingStatus

return vesting status of position


```solidity
function vestingStatus(uint256 tokenId)
    external
    view
    override
    returns (uint128 unlockedLiquidity, uint128 claimedLiquidity);
```

### _claimableLiquidity


```solidity
function _claimableLiquidity(uint256 tokenId) internal view override returns (uint128);
```

### onlyProjectAdmin


```solidity
modifier onlyProjectAdmin() override;
```

