// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import "./Common.s.sol";
import "../src/interfaces/IILOManager.sol";

contract ILOManagerInitializeScript is CommonScript {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deploymentAddress = getILOManagerDeploymentAddress();

        address _feeTaker = vm.envAddress("FEE_TAKER");
        address _initialOwner = vm.envAddress("OWNER");
        uint16 platformFee = uint16(vm.envUint("PLATFORM_FEE"));
        uint16 performanceFee = uint16(vm.envUint("PERFORMANCE_FEE"));
        address uniV3Factory = vm.envAddress("UNIV3_FACTORY");
        address weth9 = vm.envAddress("WETH9");

        vm.startBroadcast(deployerPrivateKey);
        IILOManager iloManager = IILOManager(deploymentAddress);
        iloManager.initialize(_initialOwner, _feeTaker, getILOPoolDeploymentAddress(), uniV3Factory, weth9, platformFee, performanceFee);

        vm.stopBroadcast();
    }
}
