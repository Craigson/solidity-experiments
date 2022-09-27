pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../King/KingFactory.sol";
import "../King/KingHack.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract KingTest is
    DSTest // <================ Change the Contract Name
{
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testKingHack() public {
        // <======= Change the test name
        // ========================= LEVEL SETUP
        // fund the EOA
        vm.deal(eoaAddress, 5 ether);

        // create the factory
        KingFactory kingFactory = new KingFactory(); //

        // register the level
        ethernaut.registerLevel(kingFactory);

        // start pranking the user
        vm.startPrank(eoaAddress);

        // instantiate the level
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(
            kingFactory
        );
        King ethernaughtKing = King(payable(levelAddress));

        // =========================  ATTACK
        KingHack hack = new KingHack{value: 2 ether}(
            payable(address(ethernaughtKing))
        );

        hack.attack();

        // ========================= SUBMISSION

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
