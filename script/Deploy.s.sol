// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

import { Mint } from "../src/Mint.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run() public broadcast returns (Mint mint) {
        address owner = msg.sender;
        address usdcAddress = vm.parseAddress("0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174");
        mint = new Mint(owner, usdcAddress);
    }
}
