// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GameItem is ERC721URIStorage, Ownable {
    // Переменная для хранения следующего ID токена
    uint256 private _nextTokenId;

    constructor(address initialOwner) ERC721("GameItem", "ITM") Ownable(initialOwner) {} // Инициализация контракта (задаем владельца контракта и имя токена)
    
    // Функция для награждения игрока предметом
    function awardItem(address player, string memory tokenURI) 
        public 
        onlyOwner 
        returns (uint256) 
    {
        require(bytes(tokenURI).length > 0, "Empty tokenURI"); // Проверка на пустой URI
        require(player != address(0), "Invalid player address"); // Проверка на нулевой адрес

        uint256 tokenId = _nextTokenId++; // Генерация нового ID токена
        _mint(player, tokenId); // Минтинг токена для игрока
        _setTokenURI(tokenId, tokenURI); // Установка URI токена

        return tokenId; // Возврат ID нового токена
    }

    // Ownable функция так же позволяет:
    // 1. владельцу контракта передавать права владения
    // 2. renounceOwnership - отказаться от владения контрактом (полное удаление владельца означает, что никто не сможет управлять контрактом)

    
}