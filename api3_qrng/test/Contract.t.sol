// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";

import {console} from "forge-std/console.sol";

import "../src/Requester.sol";
import "airnode-protocol/contracts/rrp/AirnodeRrpV0.sol";

contract ContractTest is Test {
    Requester private requester;
    AirnodeRrpV0 airnode;
    address sponsor = address(99);

    // These come from API3
    bytes32 endpointIdUint256 =
        0xfb6d017bb87991b7495f563db3c8cf59ff87b09781947bb1e417006ad7f55a78;
    bytes32 endpointIdUint256Array =
        0x27cc2713e7f968e4e86ed274a051a5c8aaee9cca66946f23af6f29ecea9704c3;
    address airnodeAddress = 0x9d3C147cA16DB954873A498e0af5852AB39139f2; // for the offchain node?

    function setUp() public {
        airnode = new AirnodeRrpV0();
        requester = new Requester(address(airnode));
    }

    function testExample() public {
        console.log("testing");
        // fund the sponsorship wallet
        vm.deal(sponsor, 1 ether);

        // set sponsorship status
        vm.startPrank(sponsor);
        airnode.setSponsorshipStatus(address(requester), true);
        vm.stopPrank();

        // set request parameters
        requester.setRequestParameters(
            airnodeAddress,
            endpointIdUint256,
            endpointIdUint256Array,
            sponsor
        );

        // request the QRNG uints
        requester.requestArrayOfUints(1);
    }
}
