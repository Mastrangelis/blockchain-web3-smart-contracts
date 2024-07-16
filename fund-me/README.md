<div align="center">

  <br />

  <div>
    <img src="https://img.shields.io/badge/Solidity-363636?logo=solidity&logoColor=fff" alt="solidity" />
    <img src="https://github.com/foundry-rs/foundry/raw/master/.github/logo.png" alt="Foundry logo" align="right" width="120" />
  </div>

  <h3 align="center">Foundry Fund Me</h3>
</div>

## 📋 <a name="table">Table of Contents</a>

1. 🤖 [Introduction](#introduction)
2. ⚙️ [Tech Stack](#tech-stack)
3. <img src="https://github.com/foundry-rs/foundry/raw/master/.github/logo.png" alt="Foundry logo" align="left" width="20" style="margin-right: 3px;"/> [Foundry](#foundry)

## <a name="introduction">🤖 Introduction</a>

This is part of the Cyfrin Updraft Solidity Blockchain Course.

You can read more [here](https://github.com/Cyfrin/foundry-fund-me-cu/tree/main)

## <a name="tech-stack">⚙️ Tech Stack</a>

- Solidity: Smart contracts language on ethereum.
- Foundry: Blazing fast, portable and modular toolkit for Ethereum application development written
- Forge: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- Anvil: Local Ethereum node, akin to Ganache, Hardhat Network.
- Foundry-Devops: A repo to get the most recent deployment from a given environment in foundry. This way, you can do scripting off previous deployments in solidity.

## <a name="foundry"><img src="https://github.com/foundry-rs/foundry/raw/master/.github/logo.png" alt="Foundry logo" align="left" width="25" style="margin-right: 5px; margin-top: 1px;" /> Foundry</a>

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
