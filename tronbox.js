module.exports = {
  networks: {
    development: {
      from: 'TV7k3dM6xem2dZcusQGyEJh11vq3Ro7i4z', // Your wallet address
      privateKey: '5917c677f8e00c1af41d678bfc3330509ad16bd4cb93c9b1e4d4da9ce7295976', // Your private key (ensure this is securely managed)
      userFeePercentage: 30, // Transaction fee percentage
      feeLimit: 1e9, // Maximum transaction fee limit
      originEnergyLimit: 1e7, // Energy limit for contract execution
      fullHost: 'https://api.nileex.io', // Testnet URL (Nile Testnet)
      network_id: "*", // Connects to all available networks
    },
  },
};