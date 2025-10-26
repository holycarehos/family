// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {RewardContract} from "../src/core/reward.sol";

contract DeployReward is Script {
    function run() external {
        address hrs = vm.envAddress("HRS_ADDRESS");
        vm.startBroadcast();
        RewardContract reward = new RewardContract(hrs);
        vm.stopBroadcast();
        console2.log("REWARD_ADDRESS=", address(reward));
    }
}

