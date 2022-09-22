pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Force/ForceFactory.sol";
import "../Force/ForceHack.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract ForceHackTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    ForceHack fack;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        fack = new ForceHack();
    }

    function testForceHack() public {
        // ========================= LEVEL SETUP
        // fund the EOA
        vm.deal(eoaAddress, 5 ether);

        // create the factory
        ForceFactory forceFactory = new ForceFactory();

        // register the level
        ethernaut.registerLevel(forceFactory);

        // start pranking the user
        vm.startPrank(eoaAddress);

        // instantiate the level
        address levelAddress = ethernaut.createLevelInstance(forceFactory);
        Force ethernaughtForce = Force(payable(levelAddress));

        // =========================  ATTACK

        payable(address(fack)).transfer(1000 wei);

        uint256 balance = address(fack).balance;

        emit log_named_uint("fack balance", balance);

        fack.attackContract(payable(address(ethernaughtForce)));

        balance = address(ethernaughtForce).balance;

        emit log_named_uint("force balance", balance);

        // ========================= SUBMISSION

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
