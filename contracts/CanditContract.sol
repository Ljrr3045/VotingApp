// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CanditContract {

    uint timeOfElection;
    address owner;

    modifier onlyOwner() {
        require(tx.origin == owner);
        _;
    }

    enum ELECTIONSTATE {notStart, start}

    ELECTIONSTATE public electionState;

    event canditRegist (address _candit, uint _idCandit, string _data);

    struct Candit {
        address direction;
        uint Id;
        uint voteForPresident;
        uint voteForGovernor;
        uint voteForMayor;
    }

    Candit[] public candits;

    function initProces() internal {
        electionState = ELECTIONSTATE.notStart;
        owner = tx.origin;
    }

    function RegistCandit(address _direction) public onlyOwner {

        for(uint i = 0; i< candits.length; i++){
            if(_direction == candits[i].direction){
                revert("This candit is are registred");
            }
        }

        candits.push(Candit(_direction,(candits.length + 1),0,0,0 ));

        emit canditRegist (_direction, candits.length, "Candit registed");
    }

    function starElection () external onlyOwner{
        require (candits.length >= 2, "Need inscribe more candidates");
        electionState = ELECTIONSTATE.start;
        timeOfElection = block.timestamp + 604800;
    }
}