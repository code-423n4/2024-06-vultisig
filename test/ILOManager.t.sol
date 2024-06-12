// SPDX-License-Identifier: MIT 

pragma solidity =0.7.6;
pragma abicoder v2;

import "./IntegrationTestBase.sol"; 

contract ILOManagerTest is IntegrationTestBase {
    function setUp() external {
        _setupBase();
    }

    function testInitProject() external {
        iloManager.initProject(IILOManager.InitProjectParams({
                    saleToken: mockProject().saleToken,
                    raiseToken: mockProject().raiseToken,
                    fee: 10000,
                    initialPoolPriceX96: mockProject().initialPoolPriceX96+1, 
                    launchTime: mockProject().launchTime
                })
            );
    }

    function testInitPool() external {
        IILOManager.InitPoolParams memory params = _getInitPoolParams();
        IILOPool iloPool = IILOPool(_initPool(PROJECT_OWNER, params));
        assertEq(iloPool.MANAGER(), address(iloManager));
        assertEq(iloPool.RAISE_TOKEN(), USDC);
        assertEq(iloPool.SALE_TOKEN(), SALE_TOKEN);
        assertEq(iloPool.TICK_LOWER(), MIN_TICK_500);
        assertEq(iloPool.TICK_UPPER(), -MIN_TICK_500);
        assertEq(iloPool.name(), "KRYSTAL ILOPool V1");
        assertEq(iloPool.symbol(), "KRYSTAL-ILO-V1");
    }

    function testInitPoolInvalidVestingRecipient() external {
        IILOManager.InitPoolParams memory params = _getInitPoolParams();
        params.vestingConfigs[0].recipient = INVESTOR;
        vm.expectRevert(bytes("VR"));
        IILOPool(_initPool(PROJECT_OWNER, params));
        
        params = _getInitPoolParams();
        params.vestingConfigs[1].recipient = address(0);
        vm.expectRevert(bytes("VR"));
        IILOPool(_initPool(PROJECT_OWNER, params));
    }

    function testInitPoolNotOwner() external {
        vm.expectRevert(bytes("UA"));
        _initPool(DUMMY_ADDRESS, _getInitPoolParams());
    }

    function testInitPoolWrongInvestorVests() external {
        IILOManager.InitPoolParams memory params = _getInitPoolParams();
        params.vestingConfigs[0].shares = 1;
        vm.expectRevert(bytes("TS"));
        _initPool(PROJECT_OWNER, params);
    }

    function testInitPoolSaleStartAfterEnd() external {
        IILOManager.InitPoolParams memory params = _getInitPoolParams();
        params.start = params.end + 1;
        vm.expectRevert(bytes("PT"));
        _initPool(PROJECT_OWNER, params);
    }

    function testInitPoolSaleStartAfterLaunch() external {
        IILOManager.InitPoolParams memory params = _getInitPoolParams();
        params.start = LAUNCH_START + 1;
        params.end = LAUNCH_START + 2;
        vm.expectRevert(bytes("PT"));
        _initPool(PROJECT_OWNER, params);
    }

    function testInitPoolVestOverlap() external {
        IILOManager.InitPoolParams memory params = _getInitPoolParams();
        params.vestingConfigs[0].schedule[1].start = params.vestingConfigs[0].schedule[0].end - 1;
        vm.expectRevert(bytes("VT"));
        _initPool(PROJECT_OWNER, params);
    }

    function testInitPoolVestStartBeforeLaunch() external {
        IILOManager.InitPoolParams memory params = _getInitPoolParams();
        params.vestingConfigs[0].schedule[0].start = LAUNCH_START - 1;
        vm.expectRevert(bytes("VT"));
        _initPool(PROJECT_OWNER, params);
    }

    function testLaunchBeforeLaunchStart() external {
        IILOManager.InitPoolParams memory params = _getInitPoolParams();
        _initPool(PROJECT_OWNER, params);
        vm.warp(LAUNCH_START-1);
        vm.expectRevert(bytes("LT"));
        iloManager.launch(projectId);
    }

    function testLaunchWhenPoolLaunchRevert() external {
        IILOManager.InitPoolParams memory params = _getInitPoolParams();
        _initPool(PROJECT_OWNER, params);
        vm.warp(LAUNCH_START+1);
        vm.expectRevert();
        iloManager.launch(projectId);
    }

    function testSetStorage() external {
        vm.startPrank(MANAGER_OWNER);
        iloManager.setPlatformFee(50);
        assertEq(uint256(iloManager.PLATFORM_FEE()), 50);
        
        iloManager.setPerformanceFee(5000);
        assertEq(uint256(iloManager.PERFORMANCE_FEE()), 5000);
        
        iloManager.setPerformanceFee(5000);
        assertEq(uint256(iloManager.PERFORMANCE_FEE()), 5000);

        iloManager.setILOPoolImplementation(DUMMY_ADDRESS);
        assertEq(iloManager.ILO_POOL_IMPLEMENTATION(), DUMMY_ADDRESS);
        
        iloManager.setFeeTaker(DUMMY_ADDRESS);
        assertEq(iloManager.FEE_TAKER(), DUMMY_ADDRESS);
    }
}
