// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AccessManaged} from "@openzeppelin/contracts/access/manager/AccessManaged.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AccessControlERC20MintBase is AccessControl, ERC20 {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    event CallerNotMinter(address caller);
    event CallerNotBurner(address caller);

    constructor(address manager, address minter) ERC20("MyToken", "MTK")  {
        _grantRole(MINTER_ROLE, minter);
        _grantRole(BURNER_ROLE, minter);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); // Админом является создатель контракта
    }

    function mint (address to, uint256 amount) public {
        if (!hasRole(MINTER_ROLE, msg.sender)) {
            emit CallerNotMinter(msg.sender);
            return;
        }
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        if (!hasRole(BURNER_ROLE, msg.sender)) {
            emit CallerNotBurner(msg.sender);
            return;
        }
        _burn(from, amount);
    }
}
