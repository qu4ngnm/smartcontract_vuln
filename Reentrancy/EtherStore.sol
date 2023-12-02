// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "hardhat/console.sol";


contract EtherStore {
    mapping(address => uint) public balances;
    bool public reentrancyLock; 
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        console.log("EtherStore: User deposit success");
    }

    function withdraw() public {
        require(!reentrancyLock);
        uint bal = balances[msg.sender];
        require(bal > 0);
        (bool sent, ) = msg.sender.call{value: bal}("");
        console.log("EtherStore: User withdraw success");
        require(sent, "Failed to send Ether");
        balances[msg.sender] = 0;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}