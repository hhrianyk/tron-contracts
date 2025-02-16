const TRON = artifacts.require("./tokens/TRC20/TRON.sol");

module.exports = function (deployer) {
    deployer.deploy(TRON).then(async (instance) => {
        console.log("Contract deployed at:", instance.address);

        // Update token price
        await instance.updateTokenPrice();
        console.log("Token price successfully updated.");

        // Set the token image URL
        await instance.setTokenImageURL("https://static.tronscan.org/production/logo/trx.png");
        console.log("Token image URL has been set.");

        // Verify the token image URL
        const imageURL = await instance.getTokenImageURL();
        console.log("Retrieved Token Image URL:", imageURL);
    });
};
