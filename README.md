# EsprezzoCore
 
Esprezzo core is a chain fabric server that allows for an unlimited number of application specific sidechains as well as a global cryptocurrency ledger.


Installation

Requirements

# UNIX-based OS
Presently this has only been tested on Unix and Linux base OSes such as Ubuntu 16.04+ and MacOS. We may release a bounty for Windows compatibility in the near future. See the bounties page on the github wiki if you are interested in contributing.


# Erlang/Elixir

# PostgreSQL

# Rust
Several libraries in areas that require native performance are implemented in Rust and included in Native Implemented Function(NIFs). This requires the machine on which the code is compiled to have a version of the rustc compiler and presumably... Cargo to fetch rust dependencies

There are several ways to install Rust. Our current preference is:
`curl https://sh.rustup.rs -sSf | sh`



# C++ some network tests


To start your EsprezzoCore server (Development):

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start EsprezzCore non-interactive daemon with `mix esp.start`
  * Start EsprezzoCore with interactive console `iex -S mix esp.start`


# Default P2P Port 30343

# Contribution

## Coding Conventions

## Specs

## Testing

## Dialyzer
Dialyzer is a....

Run dialyzer with `mix ...`


# Installation

## Dependencies

# Networking
Ports are configured in ... If you reconfigure them you will need a reverse proxy to map to the correct port?? TCP?

EsprezzoCore uses it's own tcp-based wire protocol