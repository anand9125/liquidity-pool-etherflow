// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {LiquidityPool} from "./Liquidity_Pool.sol";
import {LPToken} from "./LPT.sol";

contract LiquidityPoolFactory {
    address[] public allPools; 
    mapping(address => mapping(address => address)) public getPool;
    mapping(address => PoolData[]) public userPools;
    mapping(address => PoolData) public poolData;

    struct PoolData {
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

    // Function to create a new liquidity pool
    function createPool(
        address token0,
        address token1
    ) external returns (address pool) {
        require(token0 != token1, "Tokens must be different");
        require(token0 != address(0) && token1 != address(0), "Invalid token addresses");
        require(getPool[token0][token1] == address(0), "Pool already exists");

   
        LPToken lpToken = new LPToken();

        LiquidityPool newPool = new LiquidityPool(
            token0,
            token1,
            address(lpToken)
        );

        getPool[token0][token1] = address(newPool);
        getPool[token1][token0] = address(newPool); 

        
        allPools.push(address(newPool));

        emit PoolCreated(token0, token1, address(newPool), address(lpToken));

        (uint256 reserve0, uint256 reserve1) = newPool.getReserves();

        userPools[msg.sender].push(
            PoolData({
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
    
    // Function to retrieve all pools created by a specific user
    function getPoolsByUser(address user) external view returns (PoolData[] memory) {
        return userPools[user];
    }

    // Function to retrieve all pools
    function getAllPools() external view returns (address[] memory) {
        return allPools;
    }
}