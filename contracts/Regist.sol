// SPDX-License-Identifier: MIT

///@title User registration Contract
///@author Ljrr3045
///@notice It serves to allow users to register in the system to participate in the election

pragma solidity ^0.8.1;

contract Regist {

///@notice event to register each user added to the participant list
    event registUser(address indexed _user, string indexed _data);

    struct Register {
        bool register;
        bool voting;
    }

    mapping (address => Register) public registers;

///@notice public function that allows users to register only once with their address
///@dev These data are stored in a mapping, which has a Boolean structure with the fields "registered" and "vote"
    function regis() public {
        require (registers[tx.origin].register == false, "You are register");
        registers[tx.origin] = Register(true, false);

        emit registUser(tx.origin, "User registed");
    }
}