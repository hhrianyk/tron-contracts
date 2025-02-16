// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import necessary libraries for ERC20 and Chainlink
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";   // Library for standard ERC20 token
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; // Interface to get price from Chainlink
import "@openzeppelin/contracts/access/Ownable.sol"; // Library for contract ownership, allows only the owner to execute certain operations

// The TetherToken contract extends the ERC20 standard
contract TetherToken is ERC20 {

    // Variable for accessing Chainlink Price Feed
    AggregatorV3Interface internal priceFeed;

    // Constructor of the contract
    constructor() ERC20("TetherToken", "Tether USD (USDT)") {
        // Assign the Chainlink contract address for price data retrieval (ensure to change the address based on the network)
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        
        // Mint 1 million tokens (with 18 decimal places) and assign them to the contract deployer's address
        _mint(msg.sender, 1000000000000 * 10 ** decimals());
    }

    // Function to get the latest price from Chainlink
    function getLatestPrice() public view returns (int) {
        // Fetch the latest price data (including round ID, timestamp, etc.)
        (
            uint80 roundID,   // Round ID
            int price,        // Latest price
            uint startedAt,   // Start time of the round
            uint timeStamp,   // Timestamp when the data was received
            uint80 answeredInRound   // Round ID in which this price was provided
        ) = priceFeed.latestRoundData();
        
        // Return the price
        return price;
    }

    // Utility function to convert uint to string (useful for displaying values in the UI)
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        // If the number is zero, return "0"
        if (_i == 0) {
            return "0";
        }
        
        uint j = _i;
        uint len;
        
        // Count the number of digits in the number
        while (j != 0) {
            len++;
            j /= 10;
        }
        
        // Create a byte array to store the digits as characters
        bytes memory bstr = new bytes(len);
        uint k = len;
        j = _i;
        
        // Convert the number into the byte array
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        
        // Return the result as a string
        return string(bstr);
    }
}
