
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/**
 * Chain link oracle data feed
 * Network: Sepolia
 * Data Feed: ETH/USD
 * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
 */

 
/**
 * Chain link oracle data feed
 * Network: zkSync Sepolia
 * Data Feed: ETH/USD
 * Address: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
 */

library PriceConverter {

     function getPrice() internal view returns (uint256){
        // prettier-ignore
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (
            /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        // Price of Eth in terms of USD.
        return uint256(price) * 1e10;
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}