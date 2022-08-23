pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Fallout/FalloutFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract Template is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testFallbackHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        // create the factory
        FalloutFactory falloutFactory = new FalloutFactory();

        // register the level
        ethernaut.registerLevel(falloutFactory);

        // start pranking the user
        vm.startPrank(eoaAddress);

        // instantiate the level
        address levelAddress = ethernaut.createLevelInstance(falloutFactory);
        Fallout ethernautFallout = Fallout(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        // bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
        //     payable(levelAddress)
        // );
        vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}
