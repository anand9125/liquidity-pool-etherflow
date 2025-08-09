// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {LPToken} from "../src/LPT.sol";

contract LPTtokenTest is Test {
    LPToken lpt;

    function setUp() public {
        lpt = new LPToken();
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