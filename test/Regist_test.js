const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("Regist", () => {
let Regist, regist, deployer, addr1;

    before( async () =>{
        Regist = await ethers.getContractFactory("Regist");
        regist = await Regist.deploy();
        [deployer, addr1] = await ethers.getSigners();
    });

    it("Should be able to register the user", async() =>{
      await regist.connect(addr1).regis();
      let [register, voting] = await regist.registers(addr1.address);
    
      assert(register == true);
      assert(voting == false); 
    });

    it("should not be able to register already registered user", async() =>{ 
        await expect(regist.connect(addr1).regis()).to.be.revertedWith('You are register');
    });
});