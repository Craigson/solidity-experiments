pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Reentrance/ReentranceFactory.sol";
import "../Reentrance/ReentranceHack.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract ReentrancyTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testReentrancyHack() public {
        // ========================= LEVEL SETUP
        // fund the EOA
        vm.deal(eoaAddress, 5 ether);

        // create the factory
        ReentranceFactory reentranceFactory = new ReentranceFactory(); // <=== Uncomment and replace

        // register the level
        ethernaut.registerLevel(reentranceFactory);

        // start pranking the user
        vm.startPrank(eoaAddress);

        // instantiate the level
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(
            reentranceFactory
        );
        Reentrance ethernaughtReentrance = Reentrance(payable(levelAddress));

        // =========================  ATTACK
        ReentranceHack rHack = new ReentranceHack(
            address(ethernaughtReentrance)
        );

        rHack.attack{value: 0.1 ether}();

        emit log_named_uint(
            "target balance",
            address(ethernaughtReentrance).balance
        );

        // ========================= SUBMISSION

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
