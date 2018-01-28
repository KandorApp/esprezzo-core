# Ledger Overview

Accounting UTXO vs BALANCES

Cardano: Main Ledger is UTXO sidechains are Balanced

Ethereum BALANCE

BITCOIN UTXO

# State Tries only exist in Ethereum and theoretically in Cardano sidechains

## Ethereum holds all state data in a separate Partricia Trie and holds a hash of the current state trie in every block

Taken from the Yellow Paper by Dr. Gavin Wood:
Ethereum Runtime Environment: (aka ERE) The environment which is provided to an Autonomous Object executing in the EVM. Includes the EVM but also the structure of the world state on which the EVM relies for certain I/O instructions including CALL & CREATE.

Recently I proposed something similar for EsprezzoCore that had different datastructures for sidechains. I am not sure yet whether a Patricia Trie is the best choice of data structure for this. Interestingly the Ethereum paper does not definie it as a required part of the spec, only that a hash of the "State Trie" is held in the blockchain blocks.

https://en.wikipedia.org/wiki/Radix_tree




# BlockChain

## Bitcoin holds all state data in the form of inputs and UTXOs

Bitcoin and Cardano use this. Cardano states bitcoin had the best ideas for transaction ledgers and their ledger is a Bitcoin UTXO model and does not require a state trie as seen in Ethereum. 

This may be due to the idea that Ethereum has an unacceptably tight coupling between their logic layer and their accounts/ledger/settlment layer. This appears to create complexity and could be simplified by separating the concerns. Cardano is designing against this. I like the idea of a purpose built simple ledger for settlment and accounts with a loosely coupled "control", VM or computational tier layered over it.


## Sharding
Will require an additional p2p request protocol. Cardano projects to do this but is starting small.

## OPCODE overview

http://codecoupled.org/2015/10/20/stack-machine-part-2/

# Transaction Trie

# You can read from the Blockchain for free
https://medium.com/@preethikasireddy/how-does-ethereum-work-anyway-22d1df506369

https://github.com/ethereum/wiki/wiki/Patricia-Tree

## Reference
FTS stake election PoC: https://github.com/Realiserad/fts-tree

Original FTS Paper: https://eprint.iacr.org/2014/452.pdf

Tragedy of the Commons

NOTE: http://chainhash.com/

