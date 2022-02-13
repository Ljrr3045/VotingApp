// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "./OwnerContract.sol";

contract CanditContract is OwnerContract {

    uint internal timeOfElection;
    bool private initConst;
    bool private initConst2;

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

    function initProces() public {
        require(initConst == false, "This variable are init");
        electionState = ELECTIONSTATE.notStart;
        asignOwner();
        initConst = true;
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
        require (initConst2 == false, "Election is start");
        electionState = ELECTIONSTATE.start;
        timeOfElection = block.timestamp + 604800;
        initConst2 = true;
    }
}