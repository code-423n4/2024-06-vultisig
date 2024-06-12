// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import "./Common.s.sol";

contract VerifyAllContractScript is CommonScript {
    function run() view external {
        address iloManagerDeploymentAddress = getILOManagerDeploymentAddress();
        console.log("iloManager deployment address: ", iloManagerDeploymentAddress);

        address iloPoolDeploymentAddress = getILOPoolDeploymentAddress();
        console.log("iloPool deployment address: ", iloPoolDeploymentAddress);

        console.log("\nrun script below to verify all contracts: \n");

        console.log(
            string(abi.encodePacked(
                "forge verify-contract ", 
                toHexString(iloPoolDeploymentAddress),
                " src/ILOPool.sol:ILOPool;",

                "forge verify-contract ", 
                toHexString(iloManagerDeploymentAddress),
                " src/ILOManager.sol:ILOManager"
            ))
        );
    }
}

contract VerifyILOManagerScript is CommonScript {
    function run() view external {
        address deploymentAddress = getILOManagerDeploymentAddress();
        console.log("deployment address: ", deploymentAddress);
        console.log("\nrun script below to verify contract: \n");
        console.log(
            string(abi.encodePacked(
                "forge verify-contract ", 
                toHexString(deploymentAddress),
                " src/ILOManager.sol:ILOManager"
            ))
        );    
    }
}

contract VerifyILOPoolScript is CommonScript {
    function run() view external {
        address deploymentAddress = getILOPoolDeploymentAddress();
        console.log("deployment address: ", deploymentAddress);
        console.log("\nrun script below to verify contract: \n");
        console.log(
            string(abi.encodePacked(
                "forge verify-contract ", 
                toHexString(deploymentAddress),
                " src/ILOPool.sol:ILOPool"
            ))
        );    
    }
}