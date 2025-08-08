// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LPTtoken is ERC20 {
     constructor() ERC20("Liquidity Provider Token", "LPT",100) {
     }
     function mint(address to ,uint256 amount) public {
        _mint(to,amount);
     }
     function burn (address from ,uint256 amount) public {
        _burn(from,amount);
    }
}