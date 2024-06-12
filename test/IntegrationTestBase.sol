// SPDX-License-Identifier: MIT 

pragma solidity =0.7.6;
pragma abicoder v2;

import "forge-std/Test.sol";
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "../src/ILOManager.sol";
import "../src/ILOPool.sol";

import "./Mock.t.sol";

abstract contract IntegrationTestBase is Mock, Test {
    using stdStorage for StdStorage;

    address constant MANAGER_OWNER = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // anvil#1
    address constant FEE_TAKER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8; // anvil#2
    address constant UNIV3_FACTORY = 0x1F98431c8aD98523631AE4a59f267346ea31F984; // only for eth chain
    address constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // only for eth chain
    uint16 constant PLATFORM_FEE = 10; // 0.1%
    uint16 constant PERFORMANCE_FEE = 1000; // 10%
    int24 constant MIN_TICK_500 = -887270;

    ILOManager iloManager;
    address projectId;

    function _setupBase() internal {
        uint256 mainnetFork = vm.createFork("https://rpc.ankr.com/eth", 20024256);
        vm.selectFork(mainnetFork);

        vm.startBroadcast(MANAGER_OWNER);
        ILOPool iloPoolImplementation = new ILOPool{
            salt: "salt_salt_salt"
        }();
        // console.log("iloPoolImpl:");
        // console.log(address(iloPoolImplementation));

        iloManager = new ILOManager{
            salt: "salt_salt_salt"
        }();
        // console.log("iloManager:");
        // console.log(address(iloManager));

        SALE_TOKEN = address(new ERC20{
            salt: "salt_salt_salt"
        }("SALE TOKEN", "SALE"));
        // console.log("sale token:");
        // console.log(SALE_TOKEN);



        iloManager.initialize(
                MANAGER_OWNER, 
                FEE_TAKER,
                address(iloPoolImplementation),
                UNIV3_FACTORY, 
                WETH9, 
                PLATFORM_FEE,
                PERFORMANCE_FEE
            );

        vm.stopBroadcast();

        hoax(PROJECT_OWNER);
        projectId =  iloManager.initProject(IILOManager.InitProjectParams({
                    saleToken: mockProject().saleToken,
                    raiseToken: mockProject().raiseToken,
                    fee: mockProject().fee,
                    initialPoolPriceX96: mockProject().initialPoolPriceX96, 
                    launchTime: mockProject().launchTime
                })
            );

    }

    function _getInitPoolParams() internal view returns(IILOManager.InitPoolParams memory) {
        return IILOManager.InitPoolParams({
            uniV3Pool: projectId,
            tickLower: MIN_TICK_500,
            tickUpper: -MIN_TICK_500,
            hardCap: 100000 ether,
            softCap: 80000 ether,
            maxCapPerUser: 60000 ether,
            start: SALE_START,
            end: SALE_END,
            vestingConfigs: _getVestingConfigs()
        });
    }

    function _initPool(address initializer, IILOManager.InitPoolParams memory params) internal returns(address iloPoolAddress) {
        vm.prank(initializer);
        iloPoolAddress = iloManager.initILOPool(params);
    }

    function _writeTokenBalance(address token, address who, uint256 amt) internal {
        stdstore
            .target(token)
            .sig(IERC20(token).balanceOf.selector)
            .with_key(who)
            .checked_write(amt);
    }
}
