# ERC20 Basic Token

A clean, production-ready ERC-20 token implementation with owner-controlled minting and public burning. Built using OpenZeppelin and developed, tested, and deployed with Foundry.

## Overview

ERC20 Basic Token is a minimal ERC-20 smart contract designed to demonstrate a secure and professional token implementation. It focuses on clarity, correct access control, and predictable token supply behavior — suitable for audits, integrations and client delivery.

The contract leverages OpenZeppelin's audited libraries and includes unit tests, fuzz tests, deployment scripts, and interaction scripts following modern Solidity development practices.

## Token Details

- **Token Name**: BasicToken
- **Symbol**: BSC
- **Decimals**: 18
- **Supply Type**: Mintable
- **Initial Supply**: Minted in constructor to deployer
- **Minting Authority**: Contract owner
- **Burning**: Public (any holder can burn their own tokens)

## Key Features

- ✅ Standard ERC-20 functionality (transfer, approve, transferFrom)
- ✅ Owner-controlled minting
- ✅ Public token burning
- ✅ Ownership management (transfer & renounce)
- ✅ ERC-20 compliant event emission
- ✅ Clean access control using Ownable
- ✅ Gas-efficient, readable implementation
- ✅ Comprehensive testing (unit + fuzz)
- ✅ Scripted deployment & post-deployment interactions
- ✅ Designed for fast review, easy auditability, and seamless client handover.

## Tech Stack

- **Solidity**: ^0.8.19
- **Framework**: Foundry
- **Libraries**: OpenZeppelin Contracts
- **Dev Tools**: foundry-devops

## Project Structure

```
src/
 └─ BasicToken.sol

script/
 ├─ DeployBasicToken.s.sol
 └─ Interactions.s.sol

test/
 ├─ BasicTokenTest.t.sol
 └─ Interactions.t.sol
```

## Installation

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- Git installed

### Clone and Setup

```bash
git clone <https://github.com/Hasan-512/erc20-basic-token>
cd erc20-basic-token
forge install
forge build
```

## Testing

The project includes a comprehensive test suite written with Foundry.

### Covered Scenarios

- Constructor initialization
- Owner-only minting
- Mint edge cases (zero amount, zero address)
- Public burning behavior
- Transfer and allowance logic
- Ownership transfer & renouncement
- ERC-20 event emission
- Fuzz testing for minting and burning
- Supply invariants

### Run Tests

```bash
forge test
```

### Run Tests with Verbosity

```bash
forge test -vvv
```

### Run Specific Test

```bash
forge test --match-test testMintTokens -vvv
```

### Coverage Report

```bash
forge coverage
```

## Deployment

This contract has been deployed using Foundry scripts and follows a reproducible deployment flow.

### Deployment Tooling

- `DeployBasicToken.s.sol` for deployment
- `foundry-devops` for environment management
- `Interactions.s.sol` for post-deployment interactions
- `Interactions.t.sol` for validating deployed behavior

### Deploy to Sepolia

```bash
forge script script/DeployBasicToken.s.sol --rpc-url sepolia --broadcast --verify
```

### Deployment Details

- **Network**: Sepolia Testnet
- **Contract Address**: `0x76026BFd92C82504825Df5b5FB2D85bb7F5A179f`
- **Explorer**: [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x76026BFd92C82504825Df5b5FB2D85bb7F5A179f)
- **Verification**: Source code verified on Etherscan

Deployment scripts are environment-agnostic and can be reused for testnets or mainnet with minimal configuration.

## Post-Deployment Interactions

The project includes scripts to demonstrate real-world usage after deployment:

- Minting tokens as owner
- Burning tokens as holder
- Transferring tokens
- Validating balances and supply

These interactions are both scripted and tested, ensuring correct on-chain behavior.

### Run Interactions

```bash
forge script script/Interactions.s.sol:MintBasicToken --broadcast
forge script script/Interactions.s.sol:BurnBasicToken --broadcast
```

## Example Usage

```solidity
// Mint tokens (owner only)
basicToken.mint(recipientAddress, amount);

// Burn tokens (any holder)
basicToken.burn(amount);

// Standard ERC-20 operations
basicToken.transfer(to, amount);
basicToken.approve(spender, amount);
basicToken.transferFrom(from, to, amount);
```

## Security Notes

- ✅ Uses OpenZeppelin's ERC20 and Ownable implementations
- ✅ Access control enforced via `onlyOwner`
- ✅ No external contract calls
- ✅ CEI pattern respected where applicable
- ✅ Reentrancy not applicable (no external interactions)
- ❌ **Not audited** — provided as a clean reference implementation
- ✔️ Suitable for professional audits if required

## License

This project is licensed under the MIT License.

## Author

**Hasan Ahmed**  
Solidity Developer | ERC-20 & Smart Contract Development

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues or questions, please open an issue in the repository.