// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "./Regist.sol";
import "./CanditContract.sol";

///@title Voting system contract
///@author Ljrr3045
///@notice in this contract the registration of the votes of each voter is carried out
///@dev This contract ered to Regist, CanditContract (and OwnerContract)

contract VotingSistem is Regist, CanditContract{

    ///@notice modifier to verify if the electoral process has started or finished
    modifier timeVote() {
        require (electionState == ELECTIONSTATE.start, "Election not Start");
        require (block.timestamp <= timeOfElection, "Election is end");
        _;
    }

    ///@notice modifier to verify if a reader is registered or has already made his vote
    modifier regist() {
        require(registers[tx.origin].register == true, "User not register" );
        require(registers[tx.origin].voting == false, "user already vote" );
        _;
    }

    ///@notice modifier to check if the voter's votes are valid
    ///@dev They must always be greater than 0 and less than or equal to the number of candidates
    modifier validVotes(uint _votePre, uint _voteGor, uint _voteMay) {
        require (_votePre > 0 && _votePre <= candits.length,"Your votes elections is not are valid") ;
        require (_voteGor > 0 && _voteGor <= candits.length,"Your votes elections is not are valid");
        require (_voteMay > 0 && _voteMay <= candits.length, "Your votes elections is not are valid");
        _;
    }

    ///@notice modifier to verify that a candidate does not vote for himself in any of the categories
    modifier canditVoteFor(uint _votePre, uint _voteGor, uint _voteMay) {
        require (tx.origin != candits[_votePre - 1].direction, "Not can vote for yourself for President"); 
        require (tx.origin != candits[_voteGor - 1].direction, "Not can vote for yourself for Governor");
        require (tx.origin != candits[_voteMay - 1].direction, "Not can vote for yourself for Mayor");
        _;
    }

    ///@notice event to register that a user has made a vote
    event userVote (address indexed _user, string indexed _data);

    ///@notice function so that the user can make his vote
    ///@dev needs three parameters, each one is a vote for a candidate in a specific position
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
}