// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BasicToken} from "../src/BasicToken.sol";

contract DeployBasicToken is Script {
    uint256 private constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (BasicToken) {
        vm.startBroadcast();
        BasicToken basicToken = new BasicToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return basicToken;
    }
}
