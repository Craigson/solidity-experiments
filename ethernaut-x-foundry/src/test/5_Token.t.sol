pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Token/TokenFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

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

        // =========================  ATTACK

        // ========================= SUBMISSION

        // bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
        //     payable(levelAddress)
        // );
        vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}
