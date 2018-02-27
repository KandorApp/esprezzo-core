# Core Ledger / UTXO Overview

In a transaction, the “Public Key Hash” is synonymous to a “EZP address”. (An address is derived from a the hash of your public key).
 
P2PKH is therefore an instruction on the blockchain to transfer ownership from the current owner to the new owner of the bitcoin address.

## Components of a Trnsaction

### Txn Outputs 
Locking Script: Singnature and destination

### Txn Inputs:
Components:
An unlocking script is the signature of a transaction signed with senders private key
along with his public key

Example: scriptPubKey: OP_DUP OP_HASH160 <Bob's btc address> OP_EQUALVERIFY OP_CHECKSIG

Stack/Virtual Machinf design? Elixir AST?
Both the settlment layer suppoerts a simple stack based opcode syntax to allow for logic and "smart contracts" to execute on the blockchain and be run once by every node on the network.

Gas: Charge by opcode event?



## Storyline Use Case:
Bob provides the pubkey hash to Alice. Pubkey hashes are almost always sent encoded as Bitcoin addresses, which are base58-encoded strings containing an address version number, the hash, and an error-detection checksum to catch typos. The address can be transmitted through any medium, including one-way mediums which prevent the spender from communicating with the receiver, and it can be further encoded into another format, such as a QR code containing a bitcoin: URI.

Once Alice has the address and decodes it back into a standard hash, she can create the first transaction. She creates a standard P2PKH transaction output containing instructions which allow anyone to spend that output if they can prove they control the private key corresponding to Bob’s hashed public key. These instructions are called the pubkey script or scriptPubKey.


Alan wants to send Remy 5 EZP

Remy creates a public/private key, creates a EZP address from his public key and gives this to Alan.

Alice then creates a scriptPubKey and uses Bob’s bitcoin address.



## Technical Process

Remy creates a private/public keypair and from it creates an EZP address (PublicKeyHash) which he give to AJ
This is a Base58Check encoded public key as outlined in the Crypto Readme
Elliptic Curve Digital Signature Algorithm (ECDSA) with the secp256k1 curve; secp256k1 private keys are 256 bits of random data. A copy of that data is deterministically transformed into an secp256k1 public key. Because the transformation can be reliably repeated later, the public key does not need to be stored.



AJ sends EZP to Remy:
Once AJ has Remy's address and decodes it back into a standard hash, he can create the first transaction. 

Using his wallet app, AJ creates a standard P2PKH transaction output containing instructions which allow anyone to spend that output if they can prove they control the private key corresponding to Remy's hashed public key. These instructions are called the pubkey script or scriptPubKey.

He sends this and it is included on the public blockchain

References:

http://www.talkcrypto.org/blog/2017/01/13/why-really-understanding-p2pkh-is-important/

https://www.youtube.com/watch?v=PdGRmshPXdo

ECDSA in BTC: https://www.youtube.com/watch?v=ir4dDCJhdB4 [How is bitcoin "locked" to an address - OP_CHECKSIG, locking scripts, signatures, UTXO chain]

https://www.youtube.com/watch?v=aaTchHpdpIo [Locking and unlocking scripts]

# Ledger Overview: UTXO and Account-based models.

Accounting UTXO vs BALANCES

Cardano: Main Ledger is UTXO

Ethereum: BALANCE

BITCOIN: UTXO

Esprezzo: Main Ledger is UTXO sidechains are account-based


### Notes:
Ethereum holds all state data in a separate Partricia Trie and holds a hash of the current state trie in every block.

Reference Taken from the Yellow Paper by Dr. Gavin Wood:

```Ethereum Runtime Environment: (aka ERE) The environment which is provided to an Autonomous Object executing in the EVM. Includes the EVM but also the structure of the world state on which the EVM relies for certain I/O instructions including CALL & CREATE.```

Recently I proposed something similar for EsprezzoCore that had different datastructures for sidechains. I am not sure yet whether a Patricia Trie is the best choice of data structure for this. Interestingly the Ethereum paper does not define it as a required part of the spec, only that a hash of the "State Trie" is held in the blockchain blocks.

Bitcoin holds all state data in the form of inputs and UTXOs

As seen in Bitcoin and Cardano we use a UTXO method for our main settlement ledger.

Ethereum has an arguably excessively tight coupling between their logic layer and their accounts/ledger/settlment layer. This appears to create complexity and could be simplified by separating these concerns. With EsprezzoCore we are creating a purpose built ledger for settlment and accounts with a loosely coupled "control", VM or computational tier layered over it, as well as sidechains designed specifically to hold unstructured application data.

## Opcode Design Decisions
EsprezzoCore uses a stack-based virtual machine to handle opcodes and smart contract instructions

## TODO Sidechain Design Decisioning and Details
Sidechains in EsprezzoCore exists to deliver ephemeral application data and have many of the same cryptographic characteristics as the main ledger but without the focus on UTXO based transactions.