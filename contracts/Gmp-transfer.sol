// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract gmp_transfer {
    // Struct of an actor of the network
    struct Person {
        string name;
        uint256 water;
        address wallet;
    }

    // Struct of a sale in the network
    struct Sale {
        uint256 water;
        uint256 price;
        address wallet;
        bool isSold;
    }

    // Mapping the addresses with the people of the network
    mapping(address => Person) public people;
    // Mapping to ad an ID to the sales of the network
    mapping(uint256 => Sale) public sales;
    // Count of the sales in the network
    uint256 public salesCount;

    // Function to register a new person in the network
    function registerPerson(string memory name, uint256 waterAmount) public {
        people[msg.sender] = Person(name, waterAmount, msg.sender);
    }

    // Function to register a sale in the network
    function registerSale(uint256 waterAmount, uint256 price) public {
        sales[salesCount] = Sale(
            waterAmount,
            price * 10**18,
            msg.sender,
            false
        );
        salesCount++;
    }

    // Function to buy a specific sale in the network
    function Buy(uint256 saleId) public payable {
        // Indentify the sale in the network
        Sale storage sale = sales[saleId];

        // Check if the sale is not sold yet
        require(!sale.isSold, "Sale not available");

        // Check if is giving the correct amount of ETH
        require(msg.value >= sale.price, "Add the correct amount of money!");

        // Get the address of the seller
        address seller = sale.wallet;

        // Make the transaction from the buyer to the seller
        payable(sale.wallet).transfer(msg.value);

        // Adding and removing the amount of water available for each actor in the transaction
        people[seller].water -= sale.water;
        people[msg.sender].water += sale.water;

        // Mark the sale as sold
        sale.isSold = true;
    }
}
