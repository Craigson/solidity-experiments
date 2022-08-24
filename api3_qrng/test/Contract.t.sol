// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/Requester.sol";
import "airnode-protocol/contracts/rrp/AirnodeRrpV0.sol";

contract ContractTest is Test {
    Requester private requester;
    AirnodeRrpV0 airnode;

    function setUp() public {
        airnode = new AirAirnodeRrpV0();
        requester = new Requester(address(airnode));
    }

    function testExample() public {
        assertTrue(true);
    }
}
