//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

 import {Script} from "node_modules/forge-std/Script.sol";
 import {FundMe} from "../src/FundMe.sol";
 import {HelperConfig} from "./HelperConfig.s.sol";
 
 contract DeployFundMe is Script{
    function run() external returns(FundMe)
    {
        HelperConfig helperConfig = new HelperConfig();
        address ethCorrectConfig = helperConfig.activeConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethCorrectConfig);
        vm.stopBroadcast;
        return fundMe;
    }
 }