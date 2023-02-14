// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GMPnew is ERC20 {
    constructor(uint256 initialSupply) ERC20("GMP Token", "GMP") {
        _mint(msg.sender, initialSupply);
    }

    // Relate addresses with _balances
    mapping(address => uint256) _balances;

    // Struct of an actor of the network
    struct Person {
        string _name;
        address wallet;
    }

    // Struct of a sale in the network
    struct Sale {
        uint256 amount;
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
    function registerPerson(string memory _name) public {
        people[msg.sender] = Person(_name, msg.sender);
    }

    // Function to register a sale in the network
    function registerSale(uint256 amount, uint256 price) public {
        // Check if is giving the correct amount of GMP
        require(
            _balances[msg.sender] >= amount,
            "You don't have enough funds!"
        );
        // require( sale.price <= _balances[msg.sender], "There are not enough funds to do the transfer");
        sales[salesCount] = Sale(amount, price, msg.sender, false);
        salesCount++;
    }

    // Function to buy a specific sale in the network
    function Buy(uint256 saleId) public payable returns (bool success) {
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

        // Adding and removing the amount of GMP available for each actor in the transaction
        _balances[seller] = _balances[seller] - sale.amount;
        _balances[msg.sender] = _balances[msg.sender] + sale.amount;
        emit Transfer(seller, msg.sender, sale.amount);

        // Mark the sale as sold
        sale.isSold = true;
        success = true;
    }
}
