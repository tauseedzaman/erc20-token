// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {Test} from "forge-std/Test.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    uint256 constant STARTING_BALANCE = 100 ether;

    address public BOB = makeAddr("BOB");
    address public ALICE = makeAddr("ALICE");

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        // vm.prank(msg.sender);
        // ourToken.transfer(BOB, STARTING_BALANCE);
    }

    // Initial State Tests

    function testTokenDetails() public {
        assertEq(ourToken.name(), "ETHPIF Token");
        assertEq(ourToken.symbol(), "ETHPIF");
        assertEq(ourToken.decimals(), 18);
    }

    function testTotalSupply() public {
        assertEq(ourToken.totalSupply(), 500000000 ether); // 500 million
    }

    function testOwner() public {
        assertEq(ourToken.OWNER(), msg.sender);
    }

    // Balance Tests

    function testOwnerBalance() public {
        assertEq(ourToken.balanceOf(msg.sender), 500000000 ether); // owner has 500 million tokens
    }

    function testTransfer() public {
        vm.prank(msg.sender);
        ourToken.transfer(ALICE, 50 ether);
        assertEq(ourToken.balanceOf(ALICE), 50 ether);
    }

    // Minting Tests
    function testMinting() public {
        // Mint as the owner
        address TMP_USER = makeAddr("TMP_USER");
        vm.prank(msg.sender);
        ourToken.mint(TMP_USER, 100 ether); // mint 100 tokens to TMP_USER
        assertEq(ourToken.balanceOf(TMP_USER), 100 ether); // TMP_USER has 100 tokens
        assertEq(ourToken.totalSupply(), 500000100 ether); //   total supply is 500 million + 100
    }


    // Transfer Tests

    function testTransferFromOwner() public {
        vm.prank(msg.sender); // prank the owner
        uint256 AMOUNT = 50 ether;
        ourToken.transfer(BOB, AMOUNT); // transfer 50 tokens to BOB
        assertEq(ourToken.balanceOf(BOB), AMOUNT); //  BOB has 50 tokens
    }

    // Approval Tests

    function testApproval() public {
        vm.prank(msg.sender); // prank the owner
        ourToken.approve(ALICE, 100 ether); // approve ALICE to spend 100 tokens
        assertEq(ourToken.allowance(msg.sender, ALICE), 100 ether); // msg.sender has approved ALICE to spend 100 tokens
    }

    function testAllowanceAfterTransfer() public {
        vm.prank(msg.sender); // prank the owner

        address TMP_USER = makeAddr("TMP_USER"); // create a new address

        ourToken.approve(TMP_USER, 100 ether); // approve TMP_USER to spend 100 tokens
        assertEq(ourToken.allowance(msg.sender, TMP_USER), 100 ether); // msg.sender has approved ALICE to spend 100 tokens

        vm.prank(TMP_USER); // prank the TMP_USER
        ourToken.transferFrom(msg.sender, TMP_USER, 50 ether); // transfer 50 tokens from msg.sender to TMP_USER
        assertEq(ourToken.allowance(msg.sender, TMP_USER), 50 ether); // msg.sender has approved ALICE to spend 50 tokens
    }

    // TransferFrom Tests

    function testTransferFromWithApproval() public {
        vm.prank(msg.sender); // prank the owner
        address TMP_USER = makeAddr("TMP_USER"); // create a new address
       
        ourToken.approve(TMP_USER, 100 ether);

        vm.prank(TMP_USER); // prank the TMP_USER
        ourToken.transferFrom(msg.sender, TMP_USER, 50 ether);
        assertEq(ourToken.balanceOf(TMP_USER), 50 ether);
    }


    // Edge Case Tests

    function testZeroTokenTransfer() public {
        address tmp_addr = makeAddr("tmp_addr");
        ourToken.transfer(tmp_addr, 0 ether);
        assertEq(ourToken.balanceOf(tmp_addr), 0 ether);
    }

}
