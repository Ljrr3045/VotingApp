const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("OwnerContrac", () => { 
    let CanditContract,canditContract, deployer, person2, person3;

    before(async ()=>{
        CanditContract = await ethers.getContractFactory("CanditContract");
        canditContract = await CanditContract.deploy();
        [deployer, person2, person3] = await ethers.getSigners();
    });

    it("The address I display should be the owner", async ()=> {
        await canditContract.connect(deployer).initProces();

        expect(await canditContract.owner()).to.equal(deployer.address);
    });

    it("Another address could not change the owner", async ()=> {
        await expect(canditContract.connect(person2)._transferOwnership(person3.address)).to.be.revertedWith("Is not the owner");
    });

    it("Owner should be changed", async ()=> {
        await canditContract.connect(deployer)._transferOwnership(person3.address);

        expect(await canditContract.owner()).to.equal(person3.address);
    });
});
