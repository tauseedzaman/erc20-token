// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {OurToken} from "../src/OurToken.sol";
import {Script} from "forge-std/Script.sol";

contract DeployOurToken is Script {
    function run() external returns (OurToken) {
        vm.startBroadcast(); //for/ start broadcasting events
        OurToken _ourtoken = new OurToken();
        vm.stopBroadcast(); // stop broadcasting events
        return _ourtoken;
    }
}
