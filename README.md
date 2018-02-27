# EsprezzoCore
Esprezzo core is an implementation of the ESP P2P payment and data distribution protocol. This implementation offers a multichain fabric that allows for an unlimited number of application specific sidechains as well as a global cryptocurrency ledger. The design of the core settlement layer is a UTXO style ledger. The sidechains are designed specifically for high throughput data delivery and ephemeral storage.

# Installation Requirements
There are several dependencies required to run a full network node. They are fairly commonplace items in the Linux/Unix community and should be manageable by anyone with Sysadmin/DevOps experience.

## UNIX-based OS
Presently this has only been tested on Unix and Linux base OSes such as Ubuntu 16.04+ and MacOS. We may release a bounty for Windows compatibility in the near future. See the bounties page on the github wiki if you are interested in contributing.


## Erlang/Elixir
This application runs on the Erlang Virtual Maching (BEAM) and uses features from the OTP (Open Telecom System) for distributed and concurrent processing.

## PostgreSQL
During runtime all block data is verified/validated and stored in memory but it is also
persisted to disk for faster startup. This requires PostgreSQL.

## Rust
Several libraries in areas that require native performance are implemented in Rust and included in Native Implemented Function(NIFs). This requires the machine on which the code is compiled to have a version of the rustc compiler and presumably... Cargo to fetch rust dependencies

There are several ways to install Rust. Our current preference is:
`curl https://sh.rustup.rs -sSf | sh`

## C++ some network tests

To start your EsprezzoCore server (Development):

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start EsprezzCore non-interactive daemon with `mix esp.start`
  * Start EsprezzoCore with interactive console `iex -S mix esp.start`

## Testing
To run the test suite execute the following command and expect the result shown below.
$ `MIX_ENV=test mix test`


```
EsprezzoCoreWeb.ErrorViewTest
  * test render any other (4.5ms)
  * test render 500.json (0.5ms)
  * test renders 404.json (0.3ms)

  EsprezzoCore.GenesisTest
  * test genesis block hash validates (0.6ms)
  * test genesis block saves and returns (10.3ms)
  * test transaction validators succeed on genesis block (0.6ms)
  * test genesis txn merkle root validates (0.5ms)

EsprezzoCore.SigningTest
  * test correctly creates pubkey from privkey with ecdsa (6.0ms)
  * test correctly decodes txn with native atoms (4.6ms)
  * test correctly decodes and verifies signature with public key and private keys stored as Base16 (1.9ms)
  * test correctly fails signature verification (14.0ms)
  * test bin and hex private keys match (0.00ms)
  * test correctly creates and verifies signature (5.3ms)

EsprezzoCore.HashTest
  * test correctly encodes md5 (0.05ms)
  * test correctly encodes sha224 (0.02ms)
  * test correctly encodes sha512 (0.04ms)
  * test correctly encodes sha384 (0.01ms)
  * test correctly encodes sha256 (0.01ms)

EsprezzoCore.Base58CheckTest
  * test correctly encodes (0.07ms)


Finished in 0.1 seconds
20 tests, 0 failures
```

## Dialyzer
Dialyzer is a code quality and static analysis tool for Erlang bytecode.
It helps prevent errors and type mismatches. We make extensive use of type hints eg:

@spec some_function(String.t, Integer.t) :: Boolean.t

Run dialyzer 

$`mix dialyzer`

## Contribution
If you are an Erlang/Elixir developer and are interested in contributing to this project
please submit a pull request, create an issue or email us at esp-dev@protonmail.com

## Coding Conventions
We should have some.