const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("CanditContract", () => { 
    let CanditContract, canditContract, deployer, cand1, cand2, cand3;

    before(async ()=>{
        CanditContract = await ethers.getContractFactory("CanditContract");
        canditContract = await CanditContract.deploy();
        [deployer, cand1, cand2, cand3] = await ethers.getSigners();
    });

    describe("Verification that the contract was correctly implemented", async ()=> {
        it("The initProces pseudo-constructor variables should be initialized", async() =>{
            await canditContract.connect(deployer).initProces();

            expect(await canditContract.electionState()).to.equal(0);
            expect(await canditContract.owner()).to.equal(deployer.address);
        });

        it("Error: InitProces pseudo constructor variables should not be initialized a second time", async ()=> {
            await expect(canditContract.connect(deployer).initProces()).to.be.revertedWith("This variable are init");
        });
    });

    describe("Candidate Registration Verification", async ()=> {
        it("Should be able to register candidates", async ()=>{
            await canditContract.connect(deployer).RegistCandit(cand1.address);
            await canditContract.connect(deployer).RegistCandit(cand2.address);

            let [addr1, id1] = await canditContract.candits(0);
            let [addr2, id2] = await canditContract.candits(1);

            assert(addr1 === cand1.address);
            assert(id1.toNumber() === 1);
            assert(addr2 === cand2.address);
            assert(id2.toNumber() === 2);
        });

        it("Error: Should not register the same candidate two time", async ()=> {
            await expect(canditContract.connect(deployer).RegistCandit(cand1.address)).to.be.revertedWith("This candit is are registred");
        });

        it("Error: Only can to register the owner", async ()=> {
            await expect(canditContract.connect(cand1).RegistCandit(cand3.address)).to.be.revertedWith("Is not the owner");
        });
    });

    describe("Verification that the electoral process began", async ()=> {
        it("Error: Only the admin can start the lectio", async ()=>{
            await expect(canditContract.connect(cand1).starElection()).to.be.revertedWith("Is not the owner"); 
        });

        it("The electoral process must begin", async ()=> {
            await canditContract.connect(deployer).starElection();

            let init = await canditContract.electionState();
            assert(init == 1);
        });

        it("Error: Should not start the electoral process two time", async ()=> {
            await expect(canditContract.connect(deployer).starElection()).to.be.revertedWith("Election is start");
        });

        it("Error: Should not register candidates if the election started", async ()=> {
            await expect(canditContract.connect(deployer).RegistCandit(cand3.address)).to.be.revertedWith("election started, cannot register more candidates");
        });
    });
});