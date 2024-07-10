// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { PriceConverter } from "./PriceConverter.sol";

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    // Minimum 5$ usd.
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

 
    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Allow users to send $
        // Have a minimum amount of $ to be sent
        require(msg.value.getConversionRate() >= MINIMUM_USD , "Didn't send enough eth.");
        
        // Keep track of all the funders
        funders.push(msg.sender);
        
        // Keep track of the total amount funded by each funder in a mapping
        addressToAmountFunded[msg.sender] +=  msg.value;
    }

    function widthraw() public onlyOwner {
        // for loop
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        // msg.sender = address
        // payable(msg.sender) = payable address
        // in order to send native blockchain token, eth in this case addresses need to be payable
        
        // // 1. Transfer function throws an error if gas exceeds the limit
        // //     - Transfer automatically reverts if it fails.
        // payable(msg.sender).transfer(address(this).balance);

        // // 2. Send function returns bool if gas exceeds the limit
        // bool sendStatus = payable(msg.sender).send(address(this).balance);
        // require(sendStatus, "Send failed"); // Revert send.

        // 3. Call function
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed"); // Revert call.
    }

    modifier onlyOwner () {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable { 
        fund();
    }

}