// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.19;

//deploy mocks when we are in a local anvil chain
//Keep track of contract address across different chains.

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";


contract HelperConfig is Script
{
uint8 public constant Decimals=8;
int256 public constant Initial_Price = 2000e8;

    NetWorkConfig public activeConfig;
    struct NetWorkConfig{
        address priceFeed;
    }

    constructor() {
if(block.chainid== 11155111){
activeConfig = getSepoliaEthConfig();
}else if(block.chainid==80001){
    activeConfig = getPolygonEthConfig();
}else{
    activeConfig = getorCreateAnvilEthConfig();
}
    }

    function getSepoliaEthConfig() public pure returns(NetWorkConfig memory)
    {
NetWorkConfig memory sepoliaConfig = NetWorkConfig({
    priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    });
    return sepoliaConfig;
    }

    function getPolygonEthConfig() public pure returns(NetWorkConfig memory){
        NetWorkConfig memory polygonConfig = NetWorkConfig({
            priceFeed: 0x0715A7794a1dc8e42615F059dD6e406A6594651A
        });
        return polygonConfig;
    }
    function getorCreateAnvilEthConfig() public returns(NetWorkConfig memory)
    {
        if(activeConfig.priceFeed!=address(0)){
            return activeConfig;
        }
vm.startBroadcast();
MockV3Aggregator mockPriceFeed = new MockV3Aggregator(Decimals,Initial_Price);//always use appropriate keywords in place of important arguments to make the code more easy to read and clear.
vm.stopBroadcast();
NetWorkConfig memory anvilConfig = NetWorkConfig({priceFeed : address(mockPriceFeed)});
   return anvilConfig;
    }
    
}
