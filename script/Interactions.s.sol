// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {BasicToken} from "../src/BasicToken.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

abstract contract InteractionVariables {
    uint256 mintAmount = 1 ether; // Change the amount to the amount caller to mint
    address to = msg.sender; // Change msg.sender to the address caller want to mints to
    uint256 burnAmount = 1 ether; // Change the amount to the amount caller wants to burn
}

contract MintBasicToken is Script, InteractionVariables {
    function mint(address mostRecentlyDeployed, uint256 _mintAmount, address _to) public {
        BasicToken(mostRecentlyDeployed).mint(_to, _mintAmount);
        console.log("Minted Basic Token");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicToken", block.chainid);

        vm.startBroadcast();
        mint(mostRecentlyDeployed, mintAmount, to);
        vm.stopBroadcast();
    }
}

contract BurnBasicToken is Script, InteractionVariables {
    function burn(address mostRecentlyDeployed, uint256 _burnAmount) public {
        BasicToken(mostRecentlyDeployed).burn(_burnAmount);

        console.log("Burned Basic Token");
    }

    function run() public {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicToken", block.chainid);
        vm.startBroadcast();
        burn(mostRecentlyDeployed, burnAmount);
        vm.stopBroadcast();
    }
}
