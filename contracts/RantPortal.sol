// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract RantPortal {
    uint256 totalRants;
    uint256 private randNum;

    event NewRant(address indexed from, uint256 timestamp, string message);
    
    struct Rant {
        address ranter; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    Rant[] rants;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user ranted at us.
     */
    mapping(address => uint256) public lastRantedAt;

    constructor() payable {
        

        randNum = (block.timestamp + block.difficulty) % 100;

    }
    
    function rant(string memory _message) public {
        
         /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(lastRantedAt[msg.sender] + 30 seconds < block.timestamp,"Wait 15m");

        /*
         * Update the current timestamp we have for the user
         */
        lastRantedAt[msg.sender] = block.timestamp;
     
        totalRants += 1;
        console.log("%s ranted w/ message %s", msg.sender, _message);

        rants.push(Rant(msg.sender, _message, block.timestamp));

        randNum = (block.difficulty + block.timestamp + randNum) % 100;

        if (randNum <= 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewRant(msg.sender, block.timestamp, _message);
    }

    function getAllRants() public view returns (Rant[] memory) {
        return rants;
    }

    function getTotalRants() public view returns (uint256) {
        return totalRants;
    }
}

/*testingg*/