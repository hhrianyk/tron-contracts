// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TRC20Mintable.sol";

/**
 * @title Capped token
 * @dev Mintable token with a token cap.
 */
contract TRC20Capped is TRC20Mintable {
    uint256 private _cap;

    // Constructor renamed parameter to avoid shadowing 'cap' function
    constructor(uint256 cap_) {
        require(cap_ > 0, "Cap must be greater than 0");
        _cap = cap_;
    }

    /**
     * @return the cap for the token minting.
     */
    function cap() public view returns (uint256) {
        return _cap;
    }

    // Override _mint function with proper visibility
    function _mint(address account, uint256 value) internal override {
        require(totalSupply() + value <= _cap, "Cap exceeded");
        super._mint(account, value);
    }
}

