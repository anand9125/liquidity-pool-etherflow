// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {LPToken} from "./LPT.sol";

contract  LiquidityPool{
    IERC20 public token0; 
    IERC20 public token1; 
    LPToken public lpToken; // Instance of LPToken

    uint256 public reserve0;
    uint256 public reserve1;
    uint256 public totalLiquidity;

    uint256 public constant FEE_PERCENT = 3; 

    // Constructor to initialize tokens and LP token
    constructor(address _token0, address _token1, address _lpToken) {
        token0 = IERC20(_token0); 
        token1 = IERC20(_token1); 
        lpToken = LPToken(_lpToken); 
    }

   
    function addLiquidity(
        uint256 amount0,
        uint256 amount1
    ) external returns (uint256 liquidity) {
        if (reserve0 == 0 && reserve1 == 0) {
          
            liquidity = sqrt(amount0 * amount1);
        } else {
           
            uint256 liquidity0 = (amount0 * totalLiquidity) / reserve0;
            uint256 liquidity1 = (amount1 * totalLiquidity) / reserve1;
            liquidity = min(liquidity0, liquidity1);
        }

        require(liquidity > 0, "Liquidity amount too small");

    
        token0.transferFrom(msg.sender, address(this), amount0);
        token1.transferFrom(msg.sender, address(this), amount1);

       
        lpToken.mint(msg.sender, liquidity);

        reserve0 += amount0;
        reserve1 += amount1;
        totalLiquidity += liquidity;
    }

    // Remove liquidity from the pool and burn LP tokens
    function removeLiquidity(
        uint256 liquidity
    ) external returns (uint256 amount0, uint256 amount1) {
        require(liquidity > 0, "Invalid liquidity amount");
        require(totalLiquidity > 0, "No liquidity available");

        amount0 = (liquidity * reserve0) / totalLiquidity;
        amount1 = (liquidity * reserve1) / totalLiquidity;

        require(amount0 > 0 && amount1 > 0, "Insufficient amounts");


        lpToken.burn(msg.sender, liquidity);

    
        reserve0 -= amount0;
        reserve1 -= amount1;
        totalLiquidity -= liquidity;

        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);
    }

    function getCurrentLiquidity()
        external
        view
        returns (
            uint256 currentReserve0,
            uint256 currentReserve1,
            uint256 currentTotalLiquidity
        )
    {
        currentReserve0 = reserve0;
        currentReserve1 = reserve1; 
        currentTotalLiquidity = totalLiquidity; 
    }

    // Function to get the current reserves
    function getReserves() external view returns (uint256, uint256) {
        return (reserve0, reserve1);
    }

    // Function to get token information
    function getTokenInfo()
        external
        view
        returns (address tokenA, address tokenB, address lpTokenAddress)
    {
        tokenA = address(token0); 
        tokenB = address(token1); 
        lpTokenAddress = address(lpToken); 
    }

    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256) {
        return x <= y ? x : y;
    }
}
