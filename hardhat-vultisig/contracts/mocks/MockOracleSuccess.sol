// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IOracle} from "../interfaces/IOracle.sol";

contract MockOracleSuccess is IOracle {
    function name() external view returns (string memory) {
        return "VULT/ETH Univ3TWAP";
    }
    function peek(uint256 baseAmount) external view returns (uint256) {
        return 1.5 ether;
    }
}
