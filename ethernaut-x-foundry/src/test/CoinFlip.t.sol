pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../CoinFlip/CoinFlipFactory.sol";
import "../CoinFlip/CoinFlipAttacker.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract CoinFlipTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testCoinFlipHack() public {
        // ========================= LEVEL SETUP
        // fund the EOA
        vm.deal(eoaAddress, 5 ether);

        // create the factory
        CoinFlipFactory coinFlipFactory = new CoinFlipFactory(); // <=== Uncomment and replace

        // register the level
        ethernaut.registerLevel(coinFlipFactory);

        // start pranking the user
        vm.startPrank(eoaAddress);

        // instantiate the level
        address levelAddress = ethernaut.createLevelInstance(coinFlipFactory);
        CoinFlip ethernaughtCoinflip = CoinFlip(payable(levelAddress));

        // =========================  ATTACK
        CoinFlipAttacker attacker = new CoinFlipAttacker(
            address(ethernaughtCoinflip)
        );

        for (uint256 i; i < 10; i++) {
            attacker.attack();
            console.log(
                "consecutive wins: ",
                ethernaughtCoinflip.consecutiveWins()
            );
            vm.roll(block.number + 1);
        }

        // ========================= SUBMISSION

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
