// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "./Regist.sol";
import "./CanditContract.sol";

///@title Electoral system contract V2
///@author Ljrr3045
///@notice serves as a test to check if the proxy contract can update the contract

contract VotingSistemV2 is Regist, CanditContract {

    modifier timeVote() {
        require (electionState == ELECTIONSTATE.start, "Election not Start");
        require (block.timestamp <= timeOfElection, "Election is end");
        _;
    }

    modifier regist() {
        require(registers[tx.origin].register == true, "User not register" );
        require(registers[tx.origin].voting == false, "user already vote" );
        _;
    }

    modifier validVotes(uint _votePre, uint _voteGor, uint _voteMay) {
        require (_votePre > 0 && _votePre <= candits.length,"Your votes elections is not are valid") ;
        require (_voteGor > 0 && _voteGor <= candits.length,"Your votes elections is not are valid");
        require (_voteMay > 0 && _voteMay <= candits.length,"Your votes elections is not are valid");
        _;
    }

    modifier canditVoteFor(uint _votePre, uint _voteGor, uint _voteMay) {
        require (tx.origin != candits[_votePre - 1].direction, "Not can vote for yourself for President"); 
        require (tx.origin != candits[_voteGor - 1].direction, "Not can vote for yourself for Governor");
        require (tx.origin != candits[_voteMay - 1].direction, "Not can vote for yourself for Mayor");
        _;
    }

    event userVote (address indexed _user, string indexed _data);

    function election(uint _votePresident, uint _voteGorvernor, uint _voteMayor) 
    public 
    timeVote() 
    regist() 
    validVotes(_votePresident,_voteGorvernor,_voteMayor) 
    canditVoteFor(_votePresident,_voteGorvernor,_voteMayor)
    {
        candits[_votePresident - 1].voteForPresident++;
        candits[_voteGorvernor - 1].voteForGovernor++;
        candits[_voteMayor - 1].voteForMayor++;

        registers[tx.origin].voting = true;

        emit userVote (tx.origin, "User vote");
    }

///@notice Function to check in the test if the proxy contract was updated, it only returns a boolean
    function isAv2() public pure returns(bool){
        return true;
    }
}