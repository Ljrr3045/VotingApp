const { ethers, upgrades } = require("hardhat");

async function main() {

  const VotingSistem = await ethers.getContractFactory("VotingSistem");
  const votinProxy = await upgrades.deployProxy(VotingSistem, {initializer: "initProces"});

  console.log("Address of Proxy Contract", votinProxy.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});