// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Regist.sol";
import "./CanditContract.sol";

contract VotingSistem is Regist, CanditContract {

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
        require ((_votePre > 0 && _votePre <= candits.length) && 
                (_voteGor > 0 && _votePre <= candits.length) && 
                (_voteMay > 0 && _votePre <= candits.length), "Your votes elections is not are valid" );
        _;
    }

    modifier canditVoteFor(uint _votePre, uint _voteGor, uint _voteMay) {
        require (tx.origin != candits[_votePre - 1].direction, "Not can vote for yourself for President"); 
        require (tx.origin != candits[_voteGor - 1].direction, "Not can vote for yourself for Governor");
        require (tx.origin != candits[_voteMay - 1].direction, "Not can vote for yourself for Mayor");
        _;
    }

    event userVote (address _user, string _data);

    function election(uint _votePresident, uint _voteGorvernor, uint _voteMayor) 
        public 
        timeVote 
        regist 
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