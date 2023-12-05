// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "hardhat/console.sol";


contract EtherStore_safe {
    mapping(address => uint) public balances;
    bool public reentrancyLock; 
    function deposit() public payable {
        require(!reentrancyLock);
        balances[msg.sender] += msg.value;
        console.log("EtherStore: User deposit success");
    }

    function withdraw() public {
        require(!reentrancyLock);
        reentrancyLock = true;
        uint bal = balances[msg.sender];
        require(bal > 0);
        (bool sent, ) = msg.sender.call{value: bal}("");
        console.log("EtherStore: User withdraw success");
        require(sent, "Failed to send Ether");
        balances[msg.sender] = 0;
        reentrancyLock = false;
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}