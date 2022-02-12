// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Regist {

    event registUser(address _user, string _data);

    struct Register {
        bool register;
        bool voting;
    }

    mapping (address => Register) public registers;

    function regis() public {

        require (registers[tx.origin].register == false, "You are register");
        registers[tx.origin] = Register(true, false);

        emit registUser(tx.origin, "User registed");
    }
}