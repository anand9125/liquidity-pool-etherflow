// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {LPToken} from "../src/LPT.sol";
import {LiquidityPool} from "../src/Liquidity_pool.sol";
import {ERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract CustomToken is ERC20 {
    constructor(string memory name, string memory symbol ,uint256 totalSupply) ERC20(name, symbol) {
        _mint(msg.sender, totalSupply);
    }
    function approveTOkens(address spender, uint256 amount) external {
        _approve(msg.sender, spender, amount);
    }

}
contract LiquidityPoolTest is Test, ERC20 ,LPToken{
    LiquidityPool liquidityPool;
    CustomToken token0;
    CustomToken token1;
    LPToken lpToken;

    uint256 ethTOWei = 10**18;

    function setUp() public {
        token0 = new CustomToken("Token0", "T0", 1000 * ethTOWei);
        token1 = new CustomToken("Token1", "T1", 1000 * ethTOWei);
        lpToken = new LPToken();
        liquidityPool = new LiquidityPool(address(token0), address(token1), address(lpToken));
    }

    function test_addLiquidity() public {
        token0.approveTOkens(address(liquidityPool),100 * ethTOWei);
        token1.approveTOkens(address(liquidityPool),200 * ethTOWei);
        liquidityPool.addLiquidity(100 * ethTOWei, 200 * ethTOWei);
      
        (uint256 currentReserve0, uint256 currentReserve1, uint256 currentTotalLiquidity) = liquidityPool.getCurrentLiquidity();
        assertEq(currentReserve0,100 * ethTOWei);
        assertEq(currentReserve1,200 * ethTOWei);
        assertEq(currentTotalLiquidity,141421356237309504880);

      
        uint256 reserve0 = liquidityPool.reserve0();
        uint256 reserve1 = liquidityPool.reserve1();
        uint256 totalLiquidity = liquidityPool.totalLiquidity();
        assertEq(reserve0, 100 * ethTOWei, "OK");
        assertEq(reserve1, 200 * ethTOWei, "OK");
        assertEq(totalLiquidity, 141421356237309504880, "OK");


    }
    function test_removeLiquidity() public {
        token0.approveTOkens(address(liquidityPool),100 * ethTOWei);
        token1.approveTOkens(address(liquidityPool),200 * ethTOWei);
        liquidityPool.addLiquidity(100 * ethTOWei, 200 * ethTOWei);

        assertEq(liquidityPool.totalLiquidity(),141421356237309504880);
        (uint256 currentReserve0, uint256 currentReserve1, uint256 currentTotalLiquidity) = liquidityPool.getCurrentLiquidity();
        assertEq(currentReserve0,100 * ethTOWei);
        assertEq(currentReserve1,200 * ethTOWei);
        assertEq(currentTotalLiquidity,141421356237309504880);
        
        uint256 reserve0 = liquidityPool.reserve0();
        uint256 reserve1 = liquidityPool.reserve1();
        uint256 totalLiquidity = liquidityPool.totalLiquidity();
        assertEq(reserve0, 100 * ethTOWei, "OK");
        assertEq(reserve1, 200 * ethTOWei, "OK");
        assertEq(totalLiquidity, 141421356237309504880, "OK");
    }
    
}

