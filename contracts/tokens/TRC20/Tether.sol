// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import necessary libraries
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";  // Library for standard ERC20 token functionality
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";  // Interface for Chainlink price feed
import "@openzeppelin/contracts/access/Ownable.sol";  // Library for managing contract ownership

// The TRON contract extends ERC20 and Ownable functionality
contract TRON is ERC20, Ownable {
    AggregatorV3Interface internal priceFeed;  // Interface for getting the price from Chainlink
    uint256 public tokenPrice;  // The token's price in USD (or another currency)
    string private tokenImageURL;  // URL for the token's image
    uint256 public liquidityPool;  // Total liquidity in the contract

    // Events for logging important actions
    event LiquidityAdded(address indexed provider, uint256 amount);  // Event triggered when liquidity is added
    event PriceUpdated(uint256 newPrice);  // Event triggered when the token price is updated

    // Constructor of the contract
    constructor() ERC20("USDTALEX", "TRX") Ownable() {
        tokenPrice = 1 * 10**18;  // Initial price of the token (e.g., 1 USD)
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);  // Chainlink Oracle address (replace with the correct one)
        _mint(msg.sender, 1000000 * 10**decimals());  // Minting an initial supply of tokens to the contract deployer's address
    }

    // Function to update the token price using Chainlink
    function updateTokenPrice() public {
        int price = getPrice();  // Fetch the price from Chainlink
        require(price > 0, "Invalid price");  // Ensure the fetched price is valid
        tokenPrice = uint256(price);  // Update the token's price with the fetched value
        emit PriceUpdated(tokenPrice);  // Emit the PriceUpdated event with the new price
    }

    // Function to get the current price from Chainlink
    function getPrice() public view returns (int) {
        (
            /* uint80 roundID */,
            int price,
            /* uint startedAt */,
            /* uint timeStamp */,
            /* uint80 answeredInRound */
        ) = priceFeed.latestRoundData();  // Retrieve the latest price data from the Chainlink oracle
        return price;  // Return the fetched price
    }

    // Function to add liquidity to the contract's liquidity pool
    function addLiquidity() public payable {
        require(msg.value > 0, "Must send TRX to add liquidity");  // Ensure that a positive amount of TRX is sent
        liquidityPool += msg.value;  // Increase the liquidity pool by the amount sent
        emit LiquidityAdded(msg.sender, msg.value);  // Emit the LiquidityAdded event with the provider's address and the amount
    }

    // Function to get the current liquidity balance in the contract
    function getLiquidity() public view returns (uint256) {
        return liquidityPool;  // Return the current liquidity balance
    }

    // Function to set the token's image URL (only callable by the contract owner)
    function setTokenImageURL(string memory _url) public onlyOwner {
        tokenImageURL = _url;  // Set the token image URL
    }

    // Function to get the token's image URL
    function getTokenImageURL() public view returns (string memory) {
        return tokenImageURL;  // Return the token image URL
    }
}
