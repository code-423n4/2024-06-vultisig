// SPDX-License-Identifier: BUSL-1.1 
pragma solidity >=0.7.5;
pragma abicoder v2;

import '../libraries/PoolAddress.sol';
import '../interfaces/IILOPool.sol';

interface IILOManager {

    event ProjectCreated(address indexed uniV3PoolAddress, Project project);
    event ILOPoolCreated(address indexed uniV3PoolAddress, address indexed iloPoolAddress, uint256 index);
    event PoolImplementationChanged(address indexed oldPoolImplementation, address indexed newPoolImplementation);
    event ProjectAdminChanged(address indexed uniV3PoolAddress, address oldAdmin, address newAdmin);
    event DefaultDeadlineOffsetChanged(address indexed owner, uint64 oldDeadlineOffset, uint64 newDeadlineOffset);
    event RefundDeadlineChanged(address indexed project, uint64 oldRefundDeadline, uint64 newRefundDeadline);
    event ProjectLaunch(address indexed uniV3PoolAddress);
    event ProjectRefund(address indexed project, uint256 refundAmount);

    struct Project {
        address admin;
        address saleToken;
        address raiseToken;
        uint24 fee;
        uint160 initialPoolPriceX96;
        uint64 launchTime;
        uint64 refundDeadline;
        uint16 investorShares;  // BPS shares

        // cached info
        address uniV3PoolAddress; // considered as project id
        PoolAddress.PoolKey _cachedPoolKey;
        uint16 platformFee; // BPS 10000
        uint16 performanceFee; // BPS 10000
    }

    struct InitProjectParams {
        // the sale token
        address saleToken;
        // the raise token
        address raiseToken;
        // uniswap v3 fee tier
        uint24 fee;
        // uniswap sqrtPriceX96 for initialize pool
        uint160 initialPoolPriceX96;
        // time for lauch all liquidity. Only one launch time for all ilo pools
        uint64 launchTime;
    }

    /// @notice init project with details
    /// @param params the parameters to initialize the project
    /// @return uniV3PoolAddress address of uniswap v3 pool. We use this address as project id
    function initProject(InitProjectParams calldata params) external returns(address uniV3PoolAddress);

    struct InitPoolParams {
        address uniV3Pool;
        int24 tickLower; 
        int24 tickUpper;
        uint256 hardCap; // total amount of raise tokens
        uint256 softCap; // minimum amount of raise token needed for launch pool
        uint256 maxCapPerUser; // TODO: user tiers
        uint64 start;
        uint64 end;

        // config for vests and shares. 
        // First element is allways for investor 
        // and will mint nft when investor buy ilo
        IILOVest.VestingConfig[] vestingConfigs;
    }
    /// @notice this function init an `ILO Pool` which will be used for sale and vest. One project can init many ILO Pool
    /// @notice only project admin can use this function
    /// @param params the parameters for init project
    function initILOPool(InitPoolParams calldata params) external returns(address iloPoolAddress);

    function project(address uniV3PoolAddress) external view returns (Project memory);

    /// @notice set platform fee for decrease liquidity. Platform fee is imutable among all project's pools
    function setFeeTaker(address _feeTaker) external;

    function UNIV3_FACTORY() external returns(address);
    function WETH9() external returns(address);
    function PLATFORM_FEE() external returns(uint16);
    function PERFORMANCE_FEE() external returns(uint16);
    function FEE_TAKER() external returns(address);
    function ILO_POOL_IMPLEMENTATION() external returns(address);

    function initialize(
        address initialOwner,
        address _feeTaker,
        address iloPoolImplementation,
        address uniV3Factory,
        address weth9,
        uint16 platformFee,
        uint16 performanceFee
    ) external;

    /// @notice launch all projects
    function launch(address uniV3PoolAddress) external;

    /// @notice new ilo implementation for clone
    function setILOPoolImplementation(address iloPoolImplementation) external;

    /// @notice transfer admin of project
    function transferAdminProject(address admin, address uniV3Pool) external;

    /// @notice set time offset for refund if project not launch
    function setDefaultDeadlineOffset(uint64 defaultDeadlineOffset) external;
    function setRefundDeadlineForProject(address uniV3Pool, uint64 refundDeadline) external;

    /// @notice claim all projects refund
    function claimRefund(address uniV3PoolAddress) external returns(uint256 totalRefundAmount);
}
