// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {LPTtoken} from "../src/LPT.sol";

contract LPTtokenTest is Test {
    LPTtoken lpt;

    function setUp() public {
        lpt = new LPTtoken();
    }
    function test_mintLPtoken() public {
        lpt.mint(address(this),100);
        assertEq(lpt.balanceOf(address(this)),100);
    }
    function test_burnLPtoken() public {
        lpt.mint(address(this),100);
        lpt.burn(address(this),100);
        assertEq(lpt.balanceOf(address(this)),0);
    }

}