// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title BasicToken
/// @author Hasan Ahmed
/// @notice A simple ERC20 token with owner-controlled minting and public burning
/// @dev Inherits ERC20 and Ownable from OpenZeppelin
contract BasicToken is ERC20, Ownable {
    /// @notice Deploys the BasicToken contract
    /// @dev Mints the initial supply to the deployer and sets them as the owner
    /// @param initialSupply The initial token supply minted to the deployer
    constructor(uint256 initialSupply) ERC20("BasicToken", "BSC") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    /// @notice Mints new tokens to a specified address
    /// @dev Can only be called by the contract owner
    /// @param to The address that will receive the minted tokens
    /// @param amount The number of tokens to mint
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /// @notice Burns tokens from the caller's balance
    /// @dev Reverts if the caller does not have enough tokens
    /// @param amount The number of tokens to burn
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}
