// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Liquidity_Pool.sol";
import {LPTtoken} from "./LPT.sol";

contract LiquidityPoolFactory {
    address[] public allPools;
    mapping(address => mapping(address => address)) public getPool;
    mapping(address => PoolInfo[]) public userPools; // user -> array of pool data

    struct PoolInfo {
        address poolAddress;
        address token0;
        address token1;
        address lpToken;
        uint256 reserve0;
        uint256 reserve1;
    }

    event PoolCreated(
        address indexed token0,
        address indexed token1,
        address pool,
        address lpToken
    );

    function createPool(address token0, address token1)
        external
        returns (address)
    {
        require(token0 != token1, "Tokens must be different");
        require(token0 != address(0) && token1 != address(0), "Invalid token");
        require(
            getPool[token0][token1] == address(0),
            "Pool already exists"
        );

        // Deploy LP token
        LPTtoken lpToken = new LPTtoken();

        // Deploy LiquidityPool contract
        LiquidityPool newPool = new LiquidityPool(
            token0,
            token1,
            address(lpToken)
        );

        // Map pool for both token orders
        getPool[token0][token1] = address(newPool);
        getPool[token1][token0] = address(newPool);

        // Store all pools
        allPools.push(address(newPool));

        emit PoolCreated(token0, token1, address(newPool), address(lpToken));

        // Get reserves (will be 0 initially)
        (uint256 reserve0, uint256 reserve1) = newPool.getReserves();

        // Track in user's pool list
        userPools[msg.sender].push(
            PoolInfo({
                poolAddress: address(newPool),
                token0: token0,
                token1: token1,
                lpToken: address(lpToken),
                reserve0: reserve0,
                reserve1: reserve1
            })
        );

        return address(newPool);
    }

    function getPoolsByUser(address user)
        external
        view
        returns (PoolInfo[] memory)
    {
        return userPools[user];
    }

    function getAllPools() external view returns (address[] memory) {
        return allPools;
    }
}
