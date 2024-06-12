# ILOManager
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/ILOManager.sol)

**Inherits:**
[IILOManager](/src/interfaces/IILOManager.sol/interface.IILOManager.md), Ownable, [Initializable](/src/base/Initializable.sol/abstract.Initializable.md)


## State Variables
### UNIV3_FACTORY

```solidity
address public override UNIV3_FACTORY;
```


### WETH9

```solidity
address public override WETH9;
```


### DEFAULT_DEADLINE_OFFSET

```solidity
uint64 private DEFAULT_DEADLINE_OFFSET = 7 * 24 * 60 * 60;
```


### PLATFORM_FEE

```solidity
uint16 public override PLATFORM_FEE;
```


### PERFORMANCE_FEE

```solidity
uint16 public override PERFORMANCE_FEE;
```


### FEE_TAKER

```solidity
address public override FEE_TAKER;
```


### ILO_POOL_IMPLEMENTATION

```solidity
address public override ILO_POOL_IMPLEMENTATION;
```


### _cachedProject

```solidity
mapping(address => Project) private _cachedProject;
```


### _initializedILOPools

```solidity
mapping(address => address[]) private _initializedILOPools;
```


## Functions
### constructor

*since deploy via deployer so we need to claim ownership*


```solidity
constructor();
```

### initialize


```solidity
function initialize(
    address initialOwner,
    address _feeTaker,
    address iloPoolImplementation,
    address uniV3Factory,
    address weth9,
    uint16 platformFee,
    uint16 performanceFee
) external override whenNotInitialized;
```

### onlyProjectAdmin


```solidity
modifier onlyProjectAdmin(address uniV3Pool);
```

### initProject

init project with details


```solidity
function initProject(InitProjectParams calldata params)
    external
    override
    afterInitialize
    returns (address uniV3PoolAddress);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`params`|`InitProjectParams`|the parameters to initialize the project|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`uniV3PoolAddress`|`address`|address of uniswap v3 pool. We use this address as project id|


### project


```solidity
function project(address uniV3PoolAddress) external view override returns (Project memory);
```

### initILOPool

this function init an `ILO Pool` which will be used for sale and vest. One project can init many ILO Pool


```solidity
function initILOPool(InitPoolParams calldata params)
    external
    override
    onlyProjectAdmin(params.uniV3Pool)
    returns (address iloPoolAddress);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`params`|`InitPoolParams`|the parameters for init project|


### _initUniV3PoolIfNecessary


```solidity
function _initUniV3PoolIfNecessary(PoolAddress.PoolKey memory poolKey, uint160 sqrtPriceX96)
    internal
    returns (address pool);
```

### _cacheProject


```solidity
function _cacheProject(
    address uniV3PoolAddress,
    address saleToken,
    address raiseToken,
    uint24 fee,
    uint160 initialPoolPriceX96,
    uint64 launchTime,
    uint64 refundDeadline
) internal;
```

### setPlatformFee

set platform fee for decrease liquidity. Platform fee is imutable among all project's pools


```solidity
function setPlatformFee(uint16 _platformFee) external onlyOwner;
```

### setPerformanceFee

set platform fee for decrease liquidity. Platform fee is imutable among all project's pools


```solidity
function setPerformanceFee(uint16 _performanceFee) external onlyOwner;
```

### setFeeTaker

set platform fee for decrease liquidity. Platform fee is imutable among all project's pools


```solidity
function setFeeTaker(address _feeTaker) external override onlyOwner;
```

### setILOPoolImplementation


```solidity
function setILOPoolImplementation(address iloPoolImplementation) external override onlyOwner;
```

### transferAdminProject


```solidity
function transferAdminProject(address admin, address uniV3Pool) external override onlyProjectAdmin(uniV3Pool);
```

### setDefaultDeadlineOffset


```solidity
function setDefaultDeadlineOffset(uint64 defaultDeadlineOffset) external override onlyOwner;
```

### setRefundDeadlineForProject


```solidity
function setRefundDeadlineForProject(address uniV3Pool, uint64 refundDeadline) external override onlyOwner;
```

### launch

launch all projects


```solidity
function launch(address uniV3PoolAddress) external override;
```

### claimRefund

claim all projects refund


```solidity
function claimRefund(address uniV3PoolAddress)
    external
    override
    onlyProjectAdmin(uniV3PoolAddress)
    returns (uint256 totalRefundAmount);
```

