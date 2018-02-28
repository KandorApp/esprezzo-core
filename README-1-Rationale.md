# Design Decisions

Esprezzo is primarily a payment and data delivery protocol. The core ledger borrows a lot of
concepts from previous blockchain projects such as Bitcoin and Ethereum while adding new 
functionality to acheive our goal of creating a distributed application platform
that seeks to achieve fast and cheap trnsactions as well as web scale data access.


# Core Principles

1. The core/full node should remain as simple as possible and provide only two things. 

  - The core ledger should be an immutable record of transactions where permissions are managed by tried and tested Public Key Encryption methods.

  - Sidechains should be application specific and should be expirable when no longer needed. 


2. Users should not pay exhorbitant fees to store application data on the blockchain and bloat should be mitigated by the use of paralell chains for application and ephemeral data.

3. Smart contracts should be limited in scope and complexity should pushed to middle tier ie: middleware/application layer programs.

The core protocol should remain simple and serve as a datasource/market and a record of value exchange. No application specific feautures should be allowed to creep into the core protocol although users are free to write solutions that rely on the protocol.


# Blockchains and Sidechains
The core ledger uses a UTXO model as seen in bitcoin, monero etc. This ledger exists only to store and transfer value. Sidechain/Application data does not require UTXO as actions that transfer value are settled on the main ledger. The secondary chains should be designed for performant data access and focus on minimizing storage requirements.

Data on the wire is serialized as simple binary JSON and checked/validated/decoded by the application.

