// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";

import "../src/Requester.sol";
import "airnode-protocol/contracts/rrp/AirnodeRrpV0.sol";

contract ContractTest is Test {
    Requester private requester;
    AirnodeRrpV0 airnode;

    function setUp() public {
        airnode = new AirnodeRrpV0();
        requester = new Requester(address(airnode));
    }

    function testExample() public {
        assertTrue(true);
    }
}
