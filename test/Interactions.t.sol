// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {BasicToken} from "../src/BasicToken.sol";
import {DeployBasicToken} from "../script/DeployBasicToken.s.sol";
import {MintBasicToken, BurnBasicToken, InteractionVariables} from "../script/Interactions.s.sol";

contract InteractionsTest is Test, InteractionVariables {
    BasicToken basicToken;
    address deployer;
    address alice;

    uint256 initialSupply = 1000 ether;

    function setUp() public {
        deployer = address(this);
        basicToken = new BasicToken(initialSupply);

        alice = makeAddr("alice");
    }

    function testMintMintsBasicToken() public {
        MintBasicToken mintBasicToken = new MintBasicToken();
        basicToken.transferOwnership(address(mintBasicToken));

        mintBasicToken.mint(address(basicToken), mintAmount, alice);

        assertEq(basicToken.totalSupply(), initialSupply + mintAmount);
        assertEq(basicToken.balanceOf(alice), mintAmount);
    }

    function testBurnBurnsBasicToken() public {
        MintBasicToken mintBasicToken = new MintBasicToken();
        BurnBasicToken burnBasicToken = new BurnBasicToken();

        basicToken.transferOwnership(address(mintBasicToken));

        mintBasicToken.mint(address(basicToken), burnAmount, address(burnBasicToken));

        burnBasicToken.burn(address(basicToken), burnAmount);

        assertEq(basicToken.totalSupply(), initialSupply - (mintAmount - burnAmount));
        assertEq(basicToken.balanceOf(address(burnBasicToken)), (mintAmount - burnAmount));
    }
}
