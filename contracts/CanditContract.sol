// SPDX-License-Identifier: MIT

///@title Candidate registration contract
///@author Ljrr3045
///@notice this serves so that only the owner of the contract can register candidates for the election
///@dev This contract ered to OwnerContract

pragma solidity ^0.8.1;

import "./OwnerContract.sol";

contract CanditContract is OwnerContract {

    uint internal timeOfElection;
    bool private initConst;
    bool private initConst2;
    ///@notice state variables to avoid possible entries in certain functions
    ///@dev variables are initialized to 0 and false, respectively

    ///@notice enum to specify the status of the electoral process and event to keep track of each registered candidate
    enum ELECTIONSTATE {notStart, start}

    ELECTIONSTATE public electionState;

    event canditRegist (address indexed _candit, uint indexed _idCandit, string indexed _data);

    ///@notice modifier that allows to prevent a candidate from being registered more than once
    modifier confirmCandit(address _addr){
        for(uint i = 0; i< candits.length; i++){
            if(_addr == candits[i].direction){
                revert("This candit is are registred");
            }
        }
        _;
    }

    ///@notice struct that allows saving all the data of each candidate registered in the election
    ///@dev each data series of a candidate is stored in an array
    struct Candit {
        address direction;
        uint Id;
        uint voteForPresident;
        uint voteForGovernor;
        uint voteForMayor;
    }

    Candit[] public candits;

    ///@notice Function to launch the electoral process (register candidates, register users, etc.)
    ///@dev can only be called once (when called from the proxy contract, it assigns the account that displays the contract as owner)
    function initProces() public {
        require(initConst == false, "This variable are init");
        electionState = ELECTIONSTATE.notStart;
        asignOwner();
        initConst = true;
    }

    ///@notice function to register a candidate, only the address of the candidate will be passed as a parameter
    ///@dev only the owner can call this function
    function RegistCandit(address _direction) public onlyOwner confirmCandit(_direction) {
        candits.push(Candit(_direction,(candits.length + 1),0,0,0 ));

        emit canditRegist (_direction, candits.length, "Candit registed");
    }

    ///@notice function to start the election day, assigns the period of time available to vote
    ///@dev only the owner can call this function and there must be at least two registered candidates
    function starElection () external onlyOwner{
        require (candits.length >= 2, "Need inscribe more candidates");
        require (initConst2 == false, "Election is start");
        electionState = ELECTIONSTATE.start;
        timeOfElection = block.timestamp + 604800;
        initConst2 = true;
    }
}