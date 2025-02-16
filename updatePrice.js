const TronWeb = require('tronweb');
const TRON_ABI = require('./build/contracts/TRON.json').abi; // Import ABI from contract artifacts
const axios = require('axios');

// Initialize TronWeb instance
const tronWeb = new TronWeb({
    fullHost: 'https://api.nileex.io', // Nile Testnet host
    privateKey: process.env.PRIVATE_KEY, // Private key from environment variables
});

// Liquidity pool contract address
const CONTRACT_ADDRESS = 'TNd4bYYzjB1ge7qwxuEK8hW3moLKrU5Bit'; // Replace with your contract address

// USDT token address on Nile Testnet
const USDT_ADDRESS = 'TXLAQ63Xg1NAzckPwKHvzw7CSEmLMEqcdj';

// Target token address
const TARGET_TOKEN_ADDRESS = 'TNd4bYYzjB1ge7qwxuEK8hW3moLKrU5Bit'; // Replace with your token address

// Decimal places for tokens
const USDT_DECIMALS = 6; // USDT has 6 decimal places
const TARGET_TOKEN_DECIMALS = 18; // Assume target token has 18 decimal places

/**
 * Fetches token price from CoinGecko API.
 * @param {string} tokenId - The CoinGecko token ID.
 * @returns {Promise<number>} - The price of the token in USD.
 */
async function getTokenPrice(tokenId) {
    try {
        const url = `https://api.coingecko.com/api/v3/simple/price?ids=${tokenId}&vs_currencies=usd`;
        const response = await axios.get(url);
        return response.data[tokenId].usd;
    } catch (error) {
        console.error('Error fetching token price:', error);
        throw error;
    }
}

/**
 * Calculates the amount of tokens required for liquidity provision.
 * @param {string} usdtId - The CoinGecko ID of USDT.
 * @param {string} targetTokenId - The CoinGecko ID of the target token.
 * @param {number} amountInUSD - The total amount in USD to be provided as liquidity.
 * @returns {Promise<{usdtAmount: number, targetTokenAmount: number}>} - The calculated amounts of USDT and target token.
 */
async function calculateLiquidity(usdtId, targetTokenId, amountInUSD) {
    try {
        const usdtPrice = await getTokenPrice(usdtId);
        const targetTokenPrice = await getTokenPrice(targetTokenId);

        const usdtAmount = (amountInUSD / 2) / usdtPrice; // Split the amount equally in USD
        const targetTokenAmount = (amountInUSD / 2) / targetTokenPrice;

        return { usdtAmount, targetTokenAmount };
    } catch (error) {
        console.error('Error calculating liquidity:', error);
        throw new Error('Failed to retrieve token prices');
    }
}

/**
 * Adds liquidity to the smart contract.
 * @param {string} usdtAddress - The USDT token contract address.
 * @param {string} targetTokenAddress - The target token contract address.
 * @param {number} usdtAmount - The amount of USDT to be provided.
 * @param {number} targetTokenAmount - The amount of target token to be provided.
 * @returns {Promise<string>} - The transaction result.
 */
async function addLiquidity(usdtAddress, targetTokenAddress, usdtAmount, targetTokenAmount) {
    try {
        const contract = await tronWeb.contract().at(CONTRACT_ADDRESS);

        // Convert fractional amounts to integer values based on token decimals
        const usdtAmountInWei = tronWeb.toBigNumber(usdtAmount).times(10 ** USDT_DECIMALS).toFixed(0);
        const targetTokenAmountInWei = tronWeb.toBigNumber(targetTokenAmount).times(10 ** TARGET_TOKEN_DECIMALS).toFixed(0);

        // Ensure token approvals before executing the transaction
        await contract.approve(usdtAddress, usdtAmountInWei).send({ feeLimit: 1e6 });
        await contract.approve(targetTokenAddress, targetTokenAmountInWei).send({ feeLimit: 1e6 });

        // Execute add liquidity transaction
        const result = await contract.addLiquidity(
            usdtAddress,
            targetTokenAddress,
            usdtAmountInWei,
            targetTokenAmountInWei
        ).send({ feeLimit: 1e6 });

        return result;
    } catch (error) {
        console.error('Error adding liquidity:', error);
        throw error;
    }
}

/**
 * Main execution function.
 */
async function main() {
    try {
        const amountInUSD = 100; // Total liquidity amount in USD

        // Calculate required token amounts
        const { usdtAmount, targetTokenAmount } = await calculateLiquidity(
            'tether', // CoinGecko ID for USDT
            'tron',   // CoinGecko ID for TRX (replace with your token's ID)
            amountInUSD
        );

        console.log(`Adding liquidity: ${usdtAmount} USDT and ${targetTokenAmount} of target token`);

        // Add liquidity to the pool
        const result = await addLiquidity(
            USDT_ADDRESS,
            TARGET_TOKEN_ADDRESS,
            usdtAmount,
            targetTokenAmount
        );

        console.log('Liquidity successfully added:', result);
    } catch (error) {
        console.error('Error executing main():', error);
    }
}

// Execute the script
main();