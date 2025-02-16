// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Migrations {
    address public owner;
    uint public last_completed_migration;

    constructor() {
        owner = msg.sender;
    }

    modifier restricted() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
    }

    // Upgrade function to upgrade to a new Migrations contract.
    function upgrade(address new_address) public restricted {
        Migrations upgraded = Migrations(new_address); 
        upgraded.setCompleted(last_completed_migration); 
    }
}
