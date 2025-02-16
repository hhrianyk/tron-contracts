const MyContract = artifacts.require("TRON");

module.exports = function (deployer) {
  deployer.deploy(MyContract);
};

