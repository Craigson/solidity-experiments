pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Telephone/TelephoneFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract TelephoneHack is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testTelephoneHack() public {
        // ========================= LEVEL SETUP
        // fund the EOA
        vm.deal(eoaAddress, 5 ether);

        // create the factory
        TelephoneFactory telephoneFactory = new TelephoneFactory();

        // register the level
        ethernaut.registerLevel(telephoneFactory);

        // start pranking the user
        vm.startPrank(eoaAddress);

        // instantiate the level
        address levelAddress = ethernaut.createLevelInstance(telephoneFactory);
        Telephone ethernaughtTelephone = Telephone(payable(levelAddress));

        // =========================  ATTACK

        // ========================= SUBMISSION

        // bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
        //     payable(levelAddress)
        // );
        vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}
