// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    address public OWNER;

    constructor() ERC20("ETHT Token", "ETHT") {
        _mint(msg.sender, 500000000 * 10 ** 18); // 500,000,000 ETHPI, 500 million
        OWNER = msg.sender;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == OWNER, "Only the owner can mint");
        _mint(to, amount);
    }
}
