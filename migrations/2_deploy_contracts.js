var Clinic = artifacts.require("./DonationClinic.sol");

module.exports = function(deployer) {
   deployer.deploy(Clinic);
};
