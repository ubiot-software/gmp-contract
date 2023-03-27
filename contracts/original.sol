// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GMPToken is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("GMP Token", "GMP") {}

    struct Sale {
        uint256 amount;
        uint256 price;
        address wallet;
        bool isSold;
    }

    uint256 public salesCount;

    mapping(uint256 => Sale) public sales;

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burnFrom(
        address account,
        uint256 amount
    ) public virtual override onlyOwner {
        _burn(account, amount);
    }

    function registerSale(uint256 amount, uint256 price) public {
        require(
            balanceOf(msg.sender) >= amount,
            "You don't have enough funds!"
        );
        sales[salesCount] = Sale(amount, price, msg.sender, false);
        salesCount++;
    }

    function buy(uint256 saleId) public payable {
        Sale memory sale = sales[saleId];
        require(!sale.isSold, "Sale not available");
        require(msg.value >= sale.price, "Add the correct amount of ETH!");

        payable(sale.wallet).transfer(msg.value);

        transferFrom(sale.wallet, msg.sender, sale.amount);
        emit Transfer(sale.wallet, msg.sender, sale.amount);

        sale.isSold = true;
    }
}
