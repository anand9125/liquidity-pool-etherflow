// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {LPTtoken} from "./LPT.sol";

contract LiquidityPool {
    IERC20 public token0;
    IERC20 public token1;
    LPTtoken public lpt; // instance of LPT token

    uint256 public reserve0;
    uint256 public reserve1;
    uint256 public totalLiquidity;

    uint256 public constant FEE_PERCENT = 3; // Fee is 0.3% (3/1000) — note: fee not used in this contract yet

    constructor(address _token0, address _token1, address _lpt) {
        require(_token0 != address(0) && _token1 != address(0), "Invalid token addresses");
        require(_token0 != _token1, "Tokens must be different");
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
        lpt = LPTtoken(_lpt);
    }

    // Add liquidity and mint LP tokens
    function addLiquidity(uint256 amount0, uint256 amount1) external returns (uint256 liquidity) {
        require(amount0 > 0 && amount1 > 0, "Amounts must be > 0");

        if (reserve0 == 0 && reserve1 == 0) {
            // initial liquidity
            liquidity = sqrt(amount0 * amount1);
        } else {
            // keep pool ratio: mint based on smaller proportional contribution
            uint256 liquidity0 = (amount0 * totalLiquidity) / reserve0;
            uint256 liquidity1 = (amount1 * totalLiquidity) / reserve1;
            liquidity = min(liquidity0, liquidity1);
        }

        require(liquidity > 0, "Insufficient liquidity");

        // pull tokens from provider (provider must approve beforehand)
        bool ok0 = token0.transferFrom(msg.sender, address(this), amount0);
        bool ok1 = token1.transferFrom(msg.sender, address(this), amount1);
        require(ok0 && ok1, "Token transfer failed");

        // update reserves & mint LP tokens
        reserve0 += amount0;
        reserve1 += amount1;
        totalLiquidity += liquidity;

        lpt.mint(msg.sender, liquidity);

        return liquidity;
    }

    // Remove liquidity and burn LP tokens; returns amounts of token0 and token1 returned
    function removeLiquidity(uint256 liquidity) external returns (uint256 amount0, uint256 amount1) {
        require(liquidity > 0, "Invalid liquidity amount");
        require(totalLiquidity > 0, "No liquidity available");
        // calculate proportional amounts
        amount0 = (liquidity * reserve0) / totalLiquidity;
        amount1 = (liquidity * reserve1) / totalLiquidity;

        require(amount0 > 0 && amount1 > 0, "Insufficient amounts");

        // burn LP tokens from the caller
        lpt.burn(msg.sender, liquidity);

        // update reserves and total liquidity
        reserve0 -= amount0;
        reserve1 -= amount1;
        totalLiquidity -= liquidity;

        // transfer tokens to caller
        bool ok0 = token0.transfer(msg.sender, amount0);
        bool ok1 = token1.transfer(msg.sender, amount1);
        require(ok0 && ok1, "Token transfer failed");

        return (amount0, amount1);
    }

    // Return current liquidity/reserve snapshot
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

    // Return reserves
    function getReserves() external view returns (uint256, uint256) {
        return (reserve0, reserve1);
    }

    // Return token & LP token addresses
    function getTokenInfo() external view returns (address tokenA, address tokenB, address lpTokenAddress) {
        tokenA = address(token0);
        tokenB = address(token1);
        lpTokenAddress = address(lpt);
    }

    // Babylonian method for integer square root
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
