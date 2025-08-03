// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AccessControlERC20MintBase is AccessControl, ERC20 {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event CallerNotMinter(address caller);

    constructor(address minter) ERC20("MyToken", "MTK") {
        _grantRole(MINTER_ROLE, minter);
    }

    function mint (address to, uint256 amount) public {
        if (!hasRole(MINTER_ROLE, msg.sender)) {
            emit CallerNotMinter(msg.sender);
            return;
        }
        _mint(to, amount);
    }
}
