// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
 // Functions Order:
    //// constructor
    //// receive
    //// fallback
    //// external
    //// public
    //// internal
    //// private
    //// view / pure

import {Test , console} from "node_modules/forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
contract FundMeTest is Test{
    FundMe fundMe;
    address User = makeAddr("user");
uint256 fund_Value = 10e18;


    uint256 number = 1; 




    function setUp() external { //setUp always runs first  
      // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306); If we do this we have to change it evrywhere instead we should do the below

      DeployFundMe deployFundMe = new DeployFundMe();
      fundMe = deployFundMe.run();

    }

    function testMindollarisFive() public {
       assertEq(fundMe.MINIMUM_USD(),5e18);
    }
    function testOwneridMessageSender() public {
        //humne yaha fundMe contract ke owner ko msg.sender se isliye nhi kiya hai compare kyunki us->FundMeTest->new fund
        assertEq(fundMe.getOwner(),msg.sender);
    }

    function testPriceFeedVersionisAccurate() public{
      uint256 version = fundMe.getVersion();
      assertEq(version,4);
    }
    function testFundFailsWithoutEnoughEth() public {
      vm.expectRevert();//means expecting an error to revert
      fundMe.fund();
    }
    modifier funded {
fundMe.fund{value: fund_Value}();
_;
    }
    function testFundUpdatesfundedDataStructure() public funded {
      
      uint256 amount = fundMe.getAddressToAmountFunded(address(this));
      assertEq(amount,fund_Value);
    }

   function testAddressAtIndexZeroIsOwner() public funded {
    
    assertEq(fundMe.getFunder(0),address(this));
   }

   function testOnlyOwnerIsWithdrawing() public funded {
vm.expectRevert();
fundMe.withdraw();
   }
 function testWithdrawWithASingleOwner() public funded{
  //Arrange
  uint256 startingOwnerBalance = fundMe.getOwner().balance;
  uint256 startingFundMeBalance = address(fundMe).balance;

 //Act
vm.prank(fundMe.getOwner());
fundMe.withdraw();


 //Assert
 uint256 endingOwnerBalance = fundMe.getOwner().balance;
 uint256 endingFundMeBalance = address(fundMe).balance;
 assertEq(endingFundMeBalance,0);
 assertEq(startingFundMeBalance+startingOwnerBalance,endingOwnerBalance);
 }

 function testWithdrawWithMultipleFunders() public {
  uint160 noOffunders = 10;
  uint160 funderIndex = 1;
  for(uint160 i = funderIndex ; i<noOffunders ; i++){
    hoax(address(i),fund_Value);
    fundMe.fund{value: fund_Value}();
  }

 uint256 startingOwnerBalance = fundMe.getOwner().balance;
  uint256 startingFundMeBalance = address(fundMe).balance;

//Act

vm.startPrank(fundMe.getOwner());
fundMe.withdraw();
vm.stopPrank();

//assert
assert(address(fundMe).balance ==0);
assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
 }
}