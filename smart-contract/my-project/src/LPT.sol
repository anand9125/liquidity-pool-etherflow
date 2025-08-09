// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "node_modules/@openzeppelin/contracts/access/Ownable.sol";
contract LPToken is ERC20 {
    constructor() ERC20("Liquidity Provider Token", "LPT") {}

   
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

  
    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}