// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/AccessControl.sol";

contract AccessControlERC20MintBaseTest is Test {
    AccessControlERC20MintBase token;

    address minter = address(0xA11CE);
    address user = address(0xBEEF);

    event CallerNotMinter(address caller);

    function setUp() public {
        // Деплой контракта с назначением minter
        token = new AccessControlERC20MintBase(minter);
    }

    /// @notice Проверяем, что минтер может минтить
    function testMinterCanMint() public {
        // Симулируем вызов от minter
        vm.prank(minter);
        token.mint(user, 100);

        assertEq(token.balanceOf(user), 100);
        assertEq(token.totalSupply(), 100);
    }

    /// @notice Проверяем, что не-минтер НЕ может минтить и эмитит событие
    function testNonMinterCannotMint() public {
        vm.expectEmit(true, false, false, false);
        emit CallerNotMinter(user);

        vm.prank(user);
        token.mint(user, 100);

        // Баланс не должен измениться
        assertEq(token.balanceOf(user), 0);
        assertEq(token.totalSupply(), 0);
    }

    /// @notice Проверяем, что при попытке минтить без роли вызывается событие
    function testEventEmittedForNonMinter() public {
        vm.expectEmit(true, false, false, false);
        emit CallerNotMinter(user);

        vm.prank(user);
        token.mint(user, 50);
    }

    /// @notice Проверяем, что несколько минтов от минтера суммируются
    function testMultipleMintsByMinter() public {
        vm.startPrank(minter);

        token.mint(user, 50);
        token.mint(user, 30);

        vm.stopPrank();

        assertEq(token.balanceOf(user), 80);
        assertEq(token.totalSupply(), 80);
    }
}
