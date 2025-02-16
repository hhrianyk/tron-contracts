// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Importing required libraries
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";  // Standard ERC20 token functionality
import "@openzeppelin/contracts/access/Ownable.sol";  // Ownership control for the contract

// TRON contract inheriting ERC20 and Ownable contracts
contract TRON is ERC20, Ownable {
    uint256 public tokenPrice;  // The price of the token (e.g., in USD or another asset)
    string private tokenImageURL;  // The URL for the token's image
    uint256 public liquidityPool;  // Total liquidity in the contract's pool

    // Events to log important actions within the contract
    event LiquidityAdded(address indexed provider, uint256 amount);  // Emitted when liquidity is added
    event PriceUpdated(uint256 newPrice);  // Emitted when the token price is updated

    // Constructor initializes the contract with an owner and mints an initial supply of tokens
    constructor(address initialOwner) ERC20("USDTALEX", "TRX") Ownable(initialOwner) {
        tokenPrice = 1 * 10**18;  // Set the initial price of the token (e.g., 1 USD)
        _mint(initialOwner, 1000010 * 10**decimals());  // Mint an initial supply of tokens to the initial owner's address
    }

    // Function to manually update the token price by the owner
    function updateTokenPrice(uint256 newPrice) public onlyOwner {
        require(newPrice > 0, "Invalid price");  // Ensure the new price is valid (greater than 0)
        tokenPrice = newPrice;  // Update the token price
        emit PriceUpdated(tokenPrice);  // Emit an event to log the new price
    }

    // Function to add liquidity to the contract's liquidity pool
    function addLiquidity() public payable {
        require(msg.value > 0, "Must send TRX to add liquidity");  // Ensure the transaction includes a positive amount of TRX
        liquidityPool += msg.value;  // Add the sent TRX to the liquidity pool
        emit LiquidityAdded(msg.sender, msg.value);  // Emit an event with the provider's address and the amount of liquidity added
    }

    // Function to retrieve the current liquidity balance of the contract
    function getLiquidity() public view returns (uint256) {
        return liquidityPool;  // Return the current liquidity balance in the contract
    }

    // Function to set the token's image URL (only callable by the owner)
    function setTokenImageURL(string memory _url) public onlyOwner {
        tokenImageURL = _url;  // Set the image URL for the token
    }

    // Function to get the token's image URL
    function getTokenImageURL() public view returns (string memory) {
        return tokenImageURL;  // Return the current image URL for the token
    }
}
