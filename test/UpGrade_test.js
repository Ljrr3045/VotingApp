const { expect } = require("chai");

describe("UpGrade Contract", async ()=> {

  it('Should change proxy contract pointer', async () => {
    let VotingSistem = await ethers.getContractFactory("VotingSistem");
    let VotingSistemV2 = await ethers.getContractFactory("VotingSistemV2");
  
    const instance = await upgrades.deployProxy(VotingSistem, {initializer: "initProces"});
    const upgraded = await upgrades.upgradeProxy(instance.address, VotingSistemV2);

    expect(await upgraded.isAv2()).to.equal(true);
  });
});