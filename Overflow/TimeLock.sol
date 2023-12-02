// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
import "hardhat/console.sol";

contract TimeLock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
        console.log("Timelock: User deposit success and you have to wait 1 week to withdraw");
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease;
        console.log("Timelock: Increase locktime success");
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Timelock: Insufficient funds");
        require(block.timestamp > lockTime[msg.sender], "Timelock: Lock time not expired");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}