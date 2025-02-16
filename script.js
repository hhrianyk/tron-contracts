const TronWeb = require('tronweb');
const axios = require('axios'); // Ensure this is declared only once

// Network configuration
const config = {
    development: {
        fullHost: "https://api.nileex.io",
        from: 'TV7k3dM6xem2dZcusQGyEJh11vq3Ro7i4z',
        privateKey: '5917c677f8e00c1af41d678bfc3330509ad16bd4cb93c9b1e4d4da9ce7295976',
        userFeePercentage: 30,
        feeLimit: 1e9,
        originEnergyLimit: 1e7
    }
};

const tronWeb = new TronWeb({
    fullHost: config.development.fullHost,
    privateKey: config.development.privateKey
});

const contractAddress = "TRuTN85cq6hzH3rYsrEe8wtekuir87UwtH";

// Function to retrieve the contract instance
async function getContract() {
    const contract = await tronWeb.contract().at(contractAddress);
    return contract;
}

// Function to buy tokens by sending TRX to the contract
async function buyTokens(amount) {
    try {
        const contract = await getContract();
        const result = await contract.methods.buyTokens().send({
            from: config.development.from,
            callValue: tronWeb.toSun(amount)
        });
        console.log('Transaction successful:', result);
    } catch (error) {
        console.error('Transaction error:', error);
    }
}

// Execute token purchase
buyTokens(10);
