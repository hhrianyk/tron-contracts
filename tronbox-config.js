module.exports = {
  networks: {
    development: {
      privateKey: '5917c677f8e00c1af41d678bfc3330509ad16bd4cb93c9b1e4d4da9ce7295976', // Add your private key (make sure not to expose in public repos)
      consume_user_resource_percent: 30,    // Fee percent for the transaction
      fee_limit: 100000000,                 // Set a limit for how much energy and bandwidth TronBox uses
      fullHost: "https://api.nileex.io",   // Localhost URL (for local nodes) or Testnet/ Mainnet if applicable
    },
    // Uncomment and configure if using testnet or mainnet
    // testnet: {
    //   privateKey: 'your-private-key-here',
    //   fullHost: 'https://api.shasta.trongrid.io',
    //   network_id: 'testnet'
    // },
    // mainnet: {
    //   privateKey: 'your-private-key-here',
    //   fullHost: 'https://api.trongrid.io',
    //   network_id: 'mainnet'
    // }
  },
  // Optional settings
  contracts_directory: './contracts',
  contracts_build_directory: './build/contracts',
  compilers: {
    solc: {
      version: "0.8.20" // Solidity version to compile your contracts
    }
  }
};

