// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

///@title Property Verifier Contract
///@author Ljrr3045
///@notice It serves to verify the identity of the owner of the contract or that of the person who displays it
///@dev Ownership of the contract can be transferred

contract OwnerContract {
    address public owner;
    bool internal acces;

///@notice event to record property changes
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

///@notice modifier to check that only the owner can access certain functions
    modifier onlyOwner() {
        require(tx.origin == owner, "Is not the owner");
        _;
    }

///@notice function to assign the implementation address as owner
///@dev can only be executed once
    function asignOwner() internal {
        require(acces == false, "owner asgined");
        owner = tx.origin;
        acces = true;
    }

///@notice Function to transfer ownership of the contract to another address
///@dev another address must be supplied as a parameter
    function _transferOwnership(address newOwner) public onlyOwner{
    address oldOwner = owner;
    owner = newOwner;
    emit OwnershipTransferred(oldOwner, newOwner);
    }
}