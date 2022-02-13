const { expect, assert } = require("chai");
const { ethers } = require("hardhat");
const { time } = require('@openzeppelin/test-helpers');

describe("VotingSistem", () => { 
    let VotingSistem, votingSistem, deployer, cand1, cand2, per1, per2, per3;

    before(async ()=>{
        VotingSistem = await ethers.getContractFactory("VotingSistem");
        votingSistem = await VotingSistem.deploy();
        [deployer, cand1, cand2, per1, per2, per3] = await ethers.getSigners();

        await votingSistem.connect(deployer).initProces();
        await votingSistem.connect(deployer).RegistCandit(cand1.address);
        await votingSistem.connect(deployer).RegistCandit(cand2.address);
        await votingSistem.connect(per1).regis();
        await votingSistem.connect(per2).regis();
        await votingSistem.connect(cand1).regis();
        await votingSistem.connect(cand2).regis();
    });

    describe("Step 1", async ()=> {

        it("If the election hasn't started you shouldn't be able to vote",async () =>{
            await expect(votingSistem.connect(per1).election(1,1,1)).to.be.revertedWith("Election not Start");
        });

        after(async ()=> {
            await votingSistem.connect(deployer).starElection();
        });
    });

    describe("Step 2", async ()=>{

        it("should not vote if a person is not registered", async ()=> {
            await expect(votingSistem.connect(per3).election(1,1,1)).to.be.revertedWith("User not register");
        });
    });

    describe("step 3", async ()=> {
        it("Error: Election data must be valid", async ()=> {
            await expect(votingSistem.connect(per2).election(3,2,2)).to.be.revertedWith("Your votes elections is not are valid");
            await expect(votingSistem.connect(per2).election(2,3,2)).to.be.revertedWith("Your votes elections is not are valid");
            await expect(votingSistem.connect(per2).election(2,2,3)).to.be.revertedWith("Your votes elections is not are valid");
        });

        it("Error: a person cannot vote two time", async ()=>{
           await votingSistem.connect(per1).election(1,1,1);
           await expect(votingSistem.connect(per1).election(2,2,2)).to.be.revertedWith("user already vote");
        });
    });

    describe("Step 3", async ()=> {
        it("Error: A candidate should not vote for himself", async ()=> {
            await expect(votingSistem.connect(cand1).election(1,2,2)).to.be.revertedWith("Not can vote for yourself for President");
            await expect(votingSistem.connect(cand1).election(2,1,2)).to.be.revertedWith("Not can vote for yourself for Governor");
            await expect(votingSistem.connect(cand1).election(2,2,1)).to.be.revertedWith("Not can vote for yourself for Mayor");
        });
    });

    describe("step 4", async ()=> {
        it("Votes should be recorded", async ()=> {
            await votingSistem.connect(per2).election(1,2,1);

            let [adr, id, vot_pre, vot_gor, vot_may] = await votingSistem.candits(0);

            assert(vot_pre.toNumber() === 2);
            assert(vot_gor.toNumber() === 1);
            assert(vot_may.toNumber() === 2);
        });

        it("Error: you can not vote after the election is over", async ()=> {
            await time.increase(604810); 
            await expect(votingSistem.connect(per1).election(1,1,1)).to.be.revertedWith("Election is end");
        });
    });
});