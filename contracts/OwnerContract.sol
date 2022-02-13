// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

contract OwnerContract {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(tx.origin == owner, "Is not the owner");
        _;
    }

    function asignOwner() internal {
        owner = tx.origin;
    }

    function _transferOwnership(address newOwner) public onlyOwner{
    address oldOwner = owner;
    owner = newOwner;
    emit OwnershipTransferred(oldOwner, newOwner);
    }
}