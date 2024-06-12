// SPDX-License-Identifier: BUSL-1.1
pragma solidity =0.7.6;
pragma abicoder v2;

import "./interfaces/IILOManager.sol";
import "./interfaces/IILOPool.sol";
import "./libraries/ChainId.sol";
import './base/Initializable.sol';
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol';
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';
import '@uniswap/v3-core/contracts/libraries/TickMath.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/proxy/Clones.sol';

contract ILOManager is IILOManager, Ownable, Initializable {
    address public override UNIV3_FACTORY;
    address public override WETH9;

    uint64 private DEFAULT_DEADLINE_OFFSET = 7 * 24 * 60 * 60; // 7 days
    uint16 public override PLATFORM_FEE;
    uint16 public override PERFORMANCE_FEE;
    address public override FEE_TAKER;
    address public override ILO_POOL_IMPLEMENTATION;

    mapping(address => Project) private _cachedProject; // map uniV3Pool => project (aka projectId => project)
    mapping(address => address[]) private _initializedILOPools; // map uniV3Pool => list of initialized ilo pools

    /// @dev since deploy via deployer so we need to claim ownership
    constructor () {
        transferOwnership(tx.origin);
    }

    function initialize(
        address initialOwner,
        address _feeTaker,
        address iloPoolImplementation,
        address uniV3Factory,
        address weth9,
        uint16 platformFee,
        uint16 performanceFee
    ) external override whenNotInitialized() {
        PLATFORM_FEE = platformFee;
        PERFORMANCE_FEE = performanceFee;
        FEE_TAKER = _feeTaker;
        transferOwnership(initialOwner);
        UNIV3_FACTORY = uniV3Factory;
        ILO_POOL_IMPLEMENTATION = iloPoolImplementation;
        WETH9 = weth9;
    }

    modifier onlyProjectAdmin(address uniV3Pool) {
        require(_cachedProject[uniV3Pool].admin == msg.sender, "UA");
        _;
    }

    /// @inheritdoc IILOManager
    function initProject(InitProjectParams calldata params) external override afterInitialize() returns(address uniV3PoolAddress) {
        uint64 refundDeadline = params.launchTime + DEFAULT_DEADLINE_OFFSET;

        PoolAddress.PoolKey memory poolKey = PoolAddress.getPoolKey(params.saleToken, params.raiseToken, params.fee);
        uniV3PoolAddress = _initUniV3PoolIfNecessary(poolKey, params.initialPoolPriceX96);
        
        _cacheProject(uniV3PoolAddress, params.saleToken, params.raiseToken, params.fee, params.initialPoolPriceX96, params.launchTime, refundDeadline);
        emit ProjectCreated(uniV3PoolAddress, _cachedProject[uniV3PoolAddress]);
    }

    function project(address uniV3PoolAddress) external override view returns (Project memory) {
        return _cachedProject[uniV3PoolAddress];
    }

    /// @inheritdoc IILOManager
    function initILOPool(InitPoolParams calldata params) external override onlyProjectAdmin(params.uniV3Pool) returns (address iloPoolAddress) {
        Project storage _project = _cachedProject[params.uniV3Pool];
        {
            require(_project.uniV3PoolAddress != address(0), "NI");
            // validate time for sale start and end compared to launch time
            require(params.start < params.end && params.end < _project.launchTime, "PT");
            // this salt make sure that pool address can not be represented in any other chains
            bytes32 salt = keccak256(abi.encodePacked(
                ChainId.get(),
                params.uniV3Pool,
                _initializedILOPools[params.uniV3Pool].length
            ));
            iloPoolAddress = Clones.cloneDeterministic(ILO_POOL_IMPLEMENTATION, salt);
            emit ILOPoolCreated(_project.uniV3PoolAddress, iloPoolAddress, _initializedILOPools[params.uniV3Pool].length);
        }

        uint160 sqrtRatioLowerX96 = TickMath.getSqrtRatioAtTick(params.tickLower);
        uint160 sqrtRatioUpperX96 = TickMath.getSqrtRatioAtTick(params.tickUpper);
        require(sqrtRatioLowerX96 < _project.initialPoolPriceX96 && sqrtRatioLowerX96 < sqrtRatioUpperX96, "RANGE");

        IILOPool.InitPoolParams memory initParams = IILOPool.InitPoolParams({
            uniV3Pool: params.uniV3Pool,
            tickLower: params.tickLower,
            tickUpper: params.tickUpper,
            sqrtRatioLowerX96: sqrtRatioLowerX96,
            sqrtRatioUpperX96: sqrtRatioUpperX96,
            hardCap: params.hardCap,
            softCap: params.softCap,
            maxCapPerUser: params.maxCapPerUser,
            start: params.start,
            end: params.end,
            vestingConfigs: params.vestingConfigs
        });
        IILOPool(iloPoolAddress).initialize(initParams);
        _initializedILOPools[params.uniV3Pool].push(iloPoolAddress);
    }

    function _initUniV3PoolIfNecessary(PoolAddress.PoolKey memory poolKey, uint160 sqrtPriceX96) internal returns (address pool) {
        pool = IUniswapV3Factory(UNIV3_FACTORY).getPool(poolKey.token0, poolKey.token1, poolKey.fee);
        if (pool == address(0)) {
            pool = IUniswapV3Factory(UNIV3_FACTORY).createPool(poolKey.token0, poolKey.token1, poolKey.fee);
            IUniswapV3Pool(pool).initialize(sqrtPriceX96);
        } else {
            (uint160 sqrtPriceX96Existing, , , , , , ) = IUniswapV3Pool(pool).slot0();
            if (sqrtPriceX96Existing == 0) {
                IUniswapV3Pool(pool).initialize(sqrtPriceX96);
            } else {
                require(sqrtPriceX96Existing == sqrtPriceX96, "UV3P");
            }
        }
    }

    function _cacheProject(
        address uniV3PoolAddress,
        address saleToken,
        address raiseToken,
        uint24 fee,
        uint160 initialPoolPriceX96,
        uint64 launchTime,
        uint64 refundDeadline
    ) internal {
        Project storage _project = _cachedProject[uniV3PoolAddress];
        require(_project.uniV3PoolAddress == address(0), "RE");

        _project.platformFee = PLATFORM_FEE;
        _project.performanceFee = PERFORMANCE_FEE;
        _project.admin = msg.sender;
        _project.saleToken = saleToken;
        _project.raiseToken = raiseToken;
        _project.fee = fee;
        _project.initialPoolPriceX96 = initialPoolPriceX96;
        _project.launchTime = launchTime;
        _project.refundDeadline = refundDeadline;
        _project.uniV3PoolAddress = uniV3PoolAddress;
        _project._cachedPoolKey = PoolAddress.getPoolKey(saleToken, raiseToken, fee);
    }

    /// @notice set platform fee for decrease liquidity. Platform fee is imutable among all project's pools
    function setPlatformFee(uint16 _platformFee) external onlyOwner() {
        PLATFORM_FEE = _platformFee;
    }

    /// @notice set platform fee for decrease liquidity. Platform fee is imutable among all project's pools
    function setPerformanceFee(uint16 _performanceFee) external onlyOwner() {
        PERFORMANCE_FEE = _performanceFee;
    }

    /// @notice set platform fee for decrease liquidity. Platform fee is imutable among all project's pools
    function setFeeTaker(address _feeTaker) external override onlyOwner() {
        FEE_TAKER = _feeTaker;
    }

    function setILOPoolImplementation(address iloPoolImplementation) external override onlyOwner() {
        emit PoolImplementationChanged(ILO_POOL_IMPLEMENTATION, iloPoolImplementation);
        ILO_POOL_IMPLEMENTATION = iloPoolImplementation;
    }

    function transferAdminProject(address admin, address uniV3Pool) external override onlyProjectAdmin(uniV3Pool) {
        Project storage _project = _cachedProject[uniV3Pool];
        _project.admin = admin;
        emit ProjectAdminChanged(uniV3Pool, msg.sender, admin);
    }

    function setDefaultDeadlineOffset(uint64 defaultDeadlineOffset) external override onlyOwner() {
        emit DefaultDeadlineOffsetChanged(owner(), DEFAULT_DEADLINE_OFFSET, defaultDeadlineOffset);
        DEFAULT_DEADLINE_OFFSET = defaultDeadlineOffset;
    }

    function setRefundDeadlineForProject(address uniV3Pool, uint64 refundDeadline) external override onlyOwner() {
        Project storage _project = _cachedProject[uniV3Pool];
        emit RefundDeadlineChanged(uniV3Pool, _project.refundDeadline, refundDeadline);
        _project.refundDeadline = refundDeadline;
    }

    /// @inheritdoc IILOManager
    function launch(address uniV3PoolAddress) external override {
        require(block.timestamp > _cachedProject[uniV3PoolAddress].launchTime, "LT");
        (uint160 sqrtPriceX96, , , , , , ) = IUniswapV3Pool(uniV3PoolAddress).slot0();
        require(_cachedProject[uniV3PoolAddress].initialPoolPriceX96 == sqrtPriceX96, "UV3P");
        address[] memory initializedPools = _initializedILOPools[uniV3PoolAddress];
        require(initializedPools.length > 0, "NP");
        for (uint256 i = 0; i < initializedPools.length; i++) {
            IILOPool(initializedPools[i]).launch();
        }

        emit ProjectLaunch(uniV3PoolAddress);
    }

    /// @inheritdoc IILOManager
    function claimRefund(address uniV3PoolAddress) external override onlyProjectAdmin(uniV3PoolAddress) returns(uint256 totalRefundAmount) {
        require(_cachedProject[uniV3PoolAddress].refundDeadline < block.timestamp, "RFT");
        address[] memory initializedPools = _initializedILOPools[uniV3PoolAddress];
        for (uint256 i = 0; i < initializedPools.length; i++) {
            totalRefundAmount += IILOPool(initializedPools[i]).claimProjectRefund(_cachedProject[uniV3PoolAddress].admin);
        }
    }
}
