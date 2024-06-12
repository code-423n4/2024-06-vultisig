# IILOManager
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/interfaces/IILOManager.sol)


## Functions
### initProject

init project with details


```solidity
function initProject(InitProjectParams calldata params) external returns (address uniV3PoolAddress);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`params`|`InitProjectParams`|the parameters to initialize the project|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`uniV3PoolAddress`|`address`|address of uniswap v3 pool. We use this address as project id|


### initILOPool

this function init an `ILO Pool` which will be used for sale and vest. One project can init many ILO Pool

only project admin can use this function


```solidity
function initILOPool(InitPoolParams calldata params) external returns (address iloPoolAddress);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`params`|`InitPoolParams`|the parameters for init project|


### project


```solidity
function project(address uniV3PoolAddress) external view returns (Project memory);
```

### setFeeTaker

set platform fee for decrease liquidity. Platform fee is imutable among all project's pools


```solidity
function setFeeTaker(address _feeTaker) external;
```

### UNIV3_FACTORY


```solidity
function UNIV3_FACTORY() external returns (address);
```

### WETH9


```solidity
function WETH9() external returns (address);
```

### PLATFORM_FEE


```solidity
function PLATFORM_FEE() external returns (uint16);
```

### PERFORMANCE_FEE


```solidity
function PERFORMANCE_FEE() external returns (uint16);
```

### FEE_TAKER


```solidity
function FEE_TAKER() external returns (address);
```

### ILO_POOL_IMPLEMENTATION


```solidity
function ILO_POOL_IMPLEMENTATION() external returns (address);
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
) external;
```

### launch

launch all projects


```solidity
function launch(address uniV3PoolAddress) external;
```

### setILOPoolImplementation

new ilo implementation for clone


```solidity
function setILOPoolImplementation(address iloPoolImplementation) external;
```

### transferAdminProject

transfer admin of project


```solidity
function transferAdminProject(address admin, address uniV3Pool) external;
```

### setDefaultDeadlineOffset

set time offset for refund if project not launch


```solidity
function setDefaultDeadlineOffset(uint64 defaultDeadlineOffset) external;
```

### setRefundDeadlineForProject


```solidity
function setRefundDeadlineForProject(address uniV3Pool, uint64 refundDeadline) external;
```

### claimRefund

claim all projects refund


```solidity
function claimRefund(address uniV3PoolAddress) external returns (uint256 totalRefundAmount);
```

## Events
### ProjectCreated

```solidity
event ProjectCreated(address indexed uniV3PoolAddress, Project project);
```

### ILOPoolCreated

```solidity
event ILOPoolCreated(address indexed uniV3PoolAddress, address indexed iloPoolAddress, uint256 index);
```

### PoolImplementationChanged

```solidity
event PoolImplementationChanged(address indexed oldPoolImplementation, address indexed newPoolImplementation);
```

### ProjectAdminChanged

```solidity
event ProjectAdminChanged(address indexed uniV3PoolAddress, address oldAdmin, address newAdmin);
```

### DefaultDeadlineOffsetChanged

```solidity
event DefaultDeadlineOffsetChanged(address indexed owner, uint64 oldDeadlineOffset, uint64 newDeadlineOffset);
```

### RefundDeadlineChanged

```solidity
event RefundDeadlineChanged(address indexed project, uint64 oldRefundDeadline, uint64 newRefundDeadline);
```

### ProjectLaunch

```solidity
event ProjectLaunch(address indexed uniV3PoolAddress);
```

### ProjectRefund

```solidity
event ProjectRefund(address indexed project, uint256 refundAmount);
```

## Structs
### Project

```solidity
struct Project {
    address admin;
    address saleToken;
    address raiseToken;
    uint24 fee;
    uint160 initialPoolPriceX96;
    uint64 launchTime;
    uint64 refundDeadline;
    uint16 investorShares;
    address uniV3PoolAddress;
    PoolAddress.PoolKey _cachedPoolKey;
    uint16 platformFee;
    uint16 performanceFee;
}
```

### InitProjectParams

```solidity
struct InitProjectParams {
    address saleToken;
    address raiseToken;
    uint24 fee;
    uint160 initialPoolPriceX96;
    uint64 launchTime;
}
```

### InitPoolParams

```solidity
struct InitPoolParams {
    address uniV3Pool;
    int24 tickLower;
    int24 tickUpper;
    uint256 hardCap;
    uint256 softCap;
    uint256 maxCapPerUser;
    uint64 start;
    uint64 end;
    IILOVest.VestingConfig[] vestingConfigs;
}
```

