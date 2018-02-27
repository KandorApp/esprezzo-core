
# Pay to Public Key Hash or "Pay to EZP Address"

## Definitions

In an EZP transaction, the “Public Key Hash” is synonymous to a payment address.
 
P2PKH is an instruction which runs on the blockchain's virtual machine to transfer ownership from the current owner to the new owner of the bitcoin address.

## Components of a Trnsaction
### Reference: TODO
```Independent Verication of Transactions

Each node verifies every transaction against a long checklist of criteria:
• The transaction’s syntax and data structure must be correct.
• Neither lists of inputs or outputs are empty.
• The transaction size in bytes is less than MAX_BLOCK_SIZE.
• Each output value, as well as the total, must be within the allowed range of values (less than total supply coins, more than the dust threshold).
• None of the inputs have hash=0, N=–1 (coinbase transactions should not be relayed).
• nLocktime is equal to INT_MAX, or nLocktime and nSequence values are satisfied according to MedianTimePast.
• The transaction size in bytes is greater than or equal to 100.
• The number of signature operations (SIGOPS) contained in the transaction is less than the signature operation limit.
• The unlocking script (scriptSig) can only push numbers on the stack, and the locking script (scriptPubkey) must match isStandard forms (this rejects “non‐ standard” transactions).
• A matching transaction in the pool, or in a block in the main branch, must exist.
• For each input, if the referenced output exists in any other transaction in the pool, the transaction must be rejected.
• For each input, look in the main branch and the transaction pool to find the ref‐ erenced output transaction. If the output transaction is missing for any input, this will be an orphan transaction. Add to the orphan transactions pool, if a matching transaction is not already in the pool.
• For each input, if the referenced output transaction is a coinbase output, it must have at least COINBASE_MATURITY (100) confirmations.
• For each input, the referenced output must exist and cannot already be spent.
• Using the referenced output transactions to get input values, check that each input value, as well as the sum, are in the allowed range of values (less than TOTAL_SUPPLY, more than 0).
• Reject if the sum of input values is less than sum of output values.
• Reject if transaction fee would be too low (minRelayTxFee) to get into an empty block.
• The unlocking scripts for each input must validate against the corresponding output locking scripts.
```

### Txn Outputs 
Locking Script: Signature and destination

### Txn Inputs:
Components:
An unlocking script is the signature of a transaction signed with senders private key
along with his public key

Example: scriptPubKey: OP_DUP OP_HASH160 <Bob's address> OP_EQUALVERIFY OP_CHECKSIG

Stack/Virtual Machinf design? Elixir AST.
Both the settlment layer suppoerts a simple stack based opcode syntax to allow for logic and "smart contracts" to execute on the blockchain and be run once by every node on the network.

Gas: Charge by opcode event.

## Storyline Use Case:

Alan wants to send Remy 5 EZP

Remy creates a public/private key, creates a EZP address from his public key and gives this to Alan.

Alan then creates a scriptPubKey and uses Remy's EZP address.

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