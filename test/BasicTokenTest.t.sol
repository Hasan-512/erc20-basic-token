// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BasicToken} from "../src/BasicToken.sol";
import {DeployBasicToken} from "../script/DeployBasicToken.s.sol";

contract BasicTokenTest is Test {
    BasicToken basicToken;

    DeployBasicToken deployBasicToken;
    BasicToken token;

    address deployer;
    address alice;
    address bob;
    address carol;

    uint256 initialSupply = 1000;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function setUp() public {
        deployBasicToken = new DeployBasicToken();
        token = deployBasicToken.run();

        deployer = address(this);
        basicToken = new BasicToken(initialSupply);

        alice = makeAddr("alice");
        bob = makeAddr("bob");
        carol = makeAddr("carol");
    }

    /* ---------- Constructor tests ---------- */
    function testConstructorSetsNameSymbolAndMint() public view {
        assertEq(basicToken.name(), "BasicToken");
        assertEq(basicToken.symbol(), "BSC");
        uint8 decimals = basicToken.decimals();
        assertTrue(decimals > 0);
        assertEq(basicToken.totalSupply(), initialSupply);
        assertEq(basicToken.balanceOf(deployer), initialSupply);
        assertEq(basicToken.owner(), deployer);
    }

    /* ---------- Mint tests ---------- */
    function testOwnerCanMintIncreasesBalanceAndTotalSupply() public {
        uint256 beforeTotal = basicToken.totalSupply();
        basicToken.mint(alice, 10);
        uint256 afterTotal = basicToken.totalSupply();

        assertEq(afterTotal - beforeTotal, 10);
        assertEq(basicToken.balanceOf(alice), 10);
    }

    function testMintNonOwnerReverts() public {
        vm.prank(bob);
        vm.expectRevert();
        basicToken.mint(bob, 1);
    }

    function testMintZeroAmountAllowed() public {
        uint256 before = basicToken.totalSupply();
        basicToken.mint(alice, 0);
        assertEq(basicToken.totalSupply(), before);
        assertEq(basicToken.balanceOf(alice), 0);
    }

    function testMintToZeroAddressReverts() public {
        vm.expectRevert(); // _mint reverts on zero address
        basicToken.mint(address(0), 1);
    }

    /* ---------- Burn tests ---------- */
    function testBurnReducesBalanceAndTotalSupply() public {
        basicToken.mint(alice, 5);
        vm.prank(alice);
        basicToken.burn(2);

        assertEq(basicToken.balanceOf(alice), 3);
        assertEq(basicToken.totalSupply(), 1000 + 5 - 2);
    }

    function testBurnMoreThanBalanceReverts() public {
        vm.prank(bob);
        vm.expectRevert(); // ERC20 _burn will revert
        basicToken.burn(1);
    }

    function testBurnZeroAmountNoop() public {
        basicToken.mint(alice, 1);
        vm.prank(alice);
        basicToken.burn(0);
        // nothing should change
        assertEq(basicToken.balanceOf(alice), 1);
    }

    /* ---------- Transfer / Allowance tests ---------- */
    function testApproveAndTransferFromUpdatesBalancesAndAllowance() public {
        // deployer has basicTokens
        basicToken.approve(bob, 20);
        vm.prank(bob);
        basicToken.transferFrom(deployer, carol, 15);

        assertEq(basicToken.balanceOf(carol), 15);
        assertEq(basicToken.allowance(deployer, bob), 5);
    }

    function testTransferInsufficientBalanceReverts() public {
        vm.prank(alice);
        vm.expectRevert();
        basicToken.transfer(bob, 1);
    }

    /* ---------- Ownership tests ---------- */
    function testTransferOwnershipAndOnlyOwnerRestrictions() public {
        basicToken.transferOwnership(alice);
        assertEq(basicToken.owner(), alice);

        // old owner (this contract) cannot mint now
        vm.expectRevert();
        basicToken.mint(bob, 1);

        // new owner can mint
        vm.prank(alice);
        basicToken.mint(bob, 2);
        assertEq(basicToken.balanceOf(bob), 2);
    }

    function testRenounceOwnershipDisablesMint() public {
        basicToken.renounceOwnership();
        assertEq(basicToken.owner(), address(0));

        vm.expectRevert();
        basicToken.mint(alice, 1);
    }

    /* ---------- Events tests ---------- */
    function testMintEmitsTransferFromZero() public {
        vm.expectEmit(true, true, true, true, address(basicToken));
        emit Transfer(address(0), alice, 7);
        basicToken.mint(alice, 7);
    }

    function testBurnEmitsTransferToZero() public {
        basicToken.mint(alice, 4);
        vm.expectEmit(true, true, true, true, address(basicToken));
        emit Transfer(alice, address(0), 4);
        vm.prank(alice);
        basicToken.burn(4);
    }

    /* ---------- Fuzz tests ---------- */
    // Fuzz mint by owner: amount small to avoid excessive gas/overflow in test environment
    function testFuzzOwnerMint(uint256 amount) public {
        vm.assume(amount <= 1_000_000); // bound the fuzz
        basicToken.mint(alice, amount);
        assertEq(basicToken.balanceOf(alice), amount);
        // ensure totalSupply increased accordingly
        // original initial supply 1000
        assertEq(basicToken.totalSupply(), 1000 + amount);
    }

    // Fuzz burn where amount <= holder balance
    function testFuzzBurn(uint8 givenAmount) public {
        // give holder some basicTokens up to 250
        uint256 give = uint256(givenAmount) % 250;
        basicToken.mint(bob, give);
        vm.prank(bob);
        basicToken.burn(give);
        assertEq(basicToken.balanceOf(bob), 0);
    }

    /* ---------- Edge / boundary tests ---------- */
    function testVeryLargeAmountsNoOverflow() public {
        uint256 big = 1_000_000e18;
        basicToken.mint(alice, big);
        assertEq(basicToken.balanceOf(alice), big);
    }

    /* ---------- ERC20 invariant: transfer preserves totalSupply ---------- */
    function testTransferPreservesTotalSupply() public {
        uint256 before = basicToken.totalSupply();
        basicToken.transfer(alice, 10);
        assertEq(basicToken.totalSupply(), before);
    }
}
