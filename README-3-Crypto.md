# Cryptography Roadmap - [Notes, Definitions, Technical References and Code Citations]

Definitions of Address format, Key format, Public and Private Keys, Addresses and Public Hash generation process and associated Cryptographic Components related to the Core Ledger and Compatible Wallets. 

### Public Key Cryptography
Public key cryptography was invented in the 1970s and is a mathematical foundation for computer and information security.

Since the invention of public key cryptography, several suitable mathematical functions, such as prime number exponentiation and elliptic curve multiplication, have been discovered. These mathematical functions are practically irreversible, meaning that they are easy to calculate in one direction and infeasible to calculate in the opposite direction. Based on these mathematical functions, cryptography enables the cre‐ ation of digital secrets and unforgeable digital signatures. Bitcoin, Ethereum and presumably the majority of existing cryptocurrencies and blockchain-based ledgers uses elliptic curve multiplication as the basis for their cryptography.

A "wallet" contains a collection of key pairs, each consisting of a private key and a public key. The private key (k) is a number, usually picked at random. From the private key, we use elliptic curve multiplication, a one-way cryptographic function, to generate a public key (K). From the public key (K), we use a one-way cryptographic hash function to generate a public address (A).

### Mnemonic Seed Generation
A mnemonic code or sentence is superior for human interaction compared to the handling of raw binary or headecimal representations of a wallet seed. It represents a non-human-readable recovery phrase as a sentence, from which a deterministic parent private key can be derived and used to generate a series of HD/deterministic public keys and addresses.

Example:
iex >  privkey = EsprezzoCore.Crypto.PrivateKey.generate

[LOG] attend shield shaft finish neutral ignore rookie fever crash give argue same grace maximum fiber piano rate absorb trend jealous cricket where usual uniform

In binary format:
<<14, 152, 183, 19, 171, 137, 78, 225, 174, 242, 171, 50, 108, 76, 46, 95, 118,
  87, 18, 213, 109, 32, 178, 32, 27, 160, 59, 195, 55, 244, 188, 15>>

This key phrase should be stored privately for the life of the wallet.

Internally, we are starting with a 32 byte pseudo-random byte string(CSPRNG)
Example: entropy = :crypto.strong_rand_bytes(32)
This is checked against a human readable indexed list and an extra word is appended which acts as a checksum to ensure that the phrase is properly formatted.

### BIP-39
Describes the implementation of a mnemonic code or mnemonic sentence, or a group of easy to remember words for the generation of deterministic wallets.

It consists of two parts: generating the mnemonic, and converting it into a binary seed. This seed can be later used to generate deterministic wallets using BIP-0032 or similar methods.

### Cryptographically Secure Pseudorandom Number Generators (CSPRNG)
A random number generator with a sufficient level of randomness with regard to its source of entropy.

### Private Key Generation
A 32Byte/256bit random number meant to be kept private and serves as a single non-reversible master/parent private key from which public keys, addresses, can be generated determinstically.

To ensure that our private key is difficult to guess, the Standards for Efficient Cryptography Group recommends that we pick a private key between the number 1 and a number slightly smaller than  1.158e77 or:
  0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
  0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE,
  0xBA, 0xAE, 0xDC, 0xE6, 0xAF, 0x48, 0xA0, 0x3B,
  0xBF, 0xD2, 0x5E, 0x8C, 0xD0, 0x36, 0x41, 0x41

### ECDSA - Elliptical Curve Digital Signature Algorithm
Ethereum, Bitcoin and cardano use the secp256k1 curve. The same curve is used by Esprezzo.
This is used in key derivation to create a series additional addresses based on a single unique private key.

### Public Key Generation
The public key is calculated from the private key using elliptic curve multiplication, which is irreversible: K = k * G, where k is the private key, G is a constant point called the generator point, and K is the resulting public key

iex> private_key = EsprezzoCore.Crypto.PrivateKey.generate

[LOG] MNEMONIC REPRESENTATION/RECOVERY PHRASE: agree erupt area park strike submit choose soft electric night cook obvious large aunt dish dynamic reject three antique dust recycle subject spirit lonely

[LOG] PRVATE KEY BINARY REPRESENTATION: <<5, 9, 156, 45, 80, 45, 113, 176, 10, 22, 114, 71, 114, 176, 190, 204, 87, 210, 30, 143, 202, 38, 180, 252, 32, 39, 162, 43, 63, 175, 244, 132>>
 
iex> public_key = EsprezzoCore.Crypto.PrivateKey.to_public_key(private_key) 

Internally the private key is signed using an elliptic curve resulting in 65 byte/520 bit public key

iex> :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1), private_key)

[LOG] PUBLIC KEY BINARY REPRESENTATION: <<4, 183, 136, 101, 85, 218, 76, 9, 175, 213, 153, 65, 193, 226, 143, 179, 193, 90, 247, 174, 105, 97, 21, 158, 171, 208, 27, 151, 142, 38, 77, 194, 24, 79, 69, 38, 39, 36, 60, 204, 156, 255, 169, 247, 165, 49, 210, 54, 101, 195, 208, 169, 161, 110, 107, 236, 71, 240, 51, 53, 134, 219, 149, 178, 27>>

iex> public_key_viewable = :binary.decode_unsigned(public_key)

[LOG] BASE_10 REPRESENTATION:  63243624223798538740862710929779109855206744411307176361831224646023136100983087457006708434723640369534506690083305330769815435844696581856084142551577115

### Public Key Hash
Next, we pipe our public key through two hashing functions: SHA-256, followed by RIPEMD-160:

iex> private_key
|> to_public_key
|> hash(:sha256)
|> hash(:ripemd160)

We use the RIPEMD-160 hashing algorithm because it produces a short hash. The intermediate SHA-256 hashing is used to prevent insecurities through unexpected interactions between our elliptic curve signing algorithm and the RIPEMD algorithm.

### Base58
The last step in creating a public address is converting to Base58 and adding a checksum.

In order to represent long numbers in a compact way, using fewer symbols, many computer systems use mixed-alphanumeric representations with a base (or radix) higher than 10

Base58 is a binary-to-text encoding algorithm that’s designed to encode a blob of arbitrary binary data into human readable text, much like the more well known Base64 algorithm.

Unlike Base64 encoding, Bitcoin’s Base58 encoding algorithm omits characters that can be potentially confusing or ambiguous to a human reader. For example, the characters O and 0, or I and l can look similar or identical to some readers or users of certain fonts.

To avoid that ambiguity, Base58 simply removes those characters from its alphabet.

### Base58Check - Final address format
To add extra security against typos or transcription errors, Base58Check is a Base58 encoding format, frequently used in bitcoin, which has a built-in error-checking code. The checksum is an additional four bytes added to the end of the data that is being encoded. The checksum is derived from the hash of the encoded data and can therefore be used to detect and prevent transcription and typing errors. 
This prevents a mistyped bitcoin address from being accepted by the wallet software as a valid destination, an error that would otherwise result in loss of funds.

### Entire Sequence Mnemonic -> Private Key -> Public Key -> Public Key Hash -> Base58Check(Final Address)

iex> privkey = EsprezzoCore.Crypto.PrivateKey.generate
[LOG] actress rubber brass matter wood army path tongue tiny ahead bus dynamic sure expire shield moon oven riot switch enact siren brother movie mesh

iex> pubkey = EsprezzoCore.Crypto.PrivateKey.to_public_key(privkey)
[LOG] INTERMEDIATE BINARY: <<4, 112, 114, 127, 19, 1, 203, 104, 170, 154, 40, 63, 54, 198, 214, 155, 69,
  127, 153, 31, 15, 130, 9, 184, 4, 184, 61, 251, 118, 197, 114, 135, 149, 128,
  49, 53, 49, 72, 91, 174, 113, 18, 174, 174, 30, 85, 113, 196, 161, 183, 108,
  196, 159, 75, 104, 219, 117, 23, 88, 112, 2, 221, 204, 229, 40>>

iex> pubhash = EsprezzoCore.Crypto.PrivateKey.to_public_hash(pubkey)
[LOG] INTERMEDIATE BINARY: <<57, 204, 203, 215, 124, 183, 193, 248, 179, 29, 199, 1, 24, 222, 30, 146, 198,
  137, 250, 199>>

pub_address = EsprezzoCore.Crypto.PrivateKey.to_public_address(pubhash)
[LOG] BASE58CHECK public address: "1ETfvmyqzy2izPaeYsD31KG5xv5pfAr46j"

# Wallets:
### Hierarchical Deterministic Key Derivation (HD Wallets) - UPDATE
Hierarchical deterministic (HD) keys are a type of deterministic wallet derived from a known seed, that allow for the creation of child keys from the parent key. Because the child key is generated from a known seed there is a relationship between the child and parent keys that is invisible to anyone without that seed. The HD protocol (BIP 32) can generate a near infinite number of child keys from a deterministically-generated seed (chain code) from its parent, providing the functionality of being able to recreate those exact same child keys as long as you have the seed.

Instead of generating random-independent Bitcoin addresses
in your wallet file, use just one secret value as a seed that
generates a pseudorandom (deterministic) sequence of values,
and derive a Bitcoin address from each value in this sequence.

Example: privkey1=hash(seed||1), privkey2=hash(seed||2), ...

By using a key homomorphism feature of discrete-log based
cryptosystems (in particular ECDSA), we can generate the
public-key values of this deterministic sequence without
knowing their corresponding private-keys (and with no need to
access the master seed or any other highly sensitive data).

### TODO: Wallet Import Format/Storage
Define wallet file/storage format.


### References:
Pbkdf2 is a well-tested password-based key derivation function that can be configured to remain slow and resistant to brute-force attacks even as computational power increases.

Mastering Bitcoin by Andreas M. Antonopoulos: (https://github.com/bitcoinbook/bitcoinbook/tree/second_edition)

https://en.wikipedia.org/wiki/Key_derivation_function

https://trac.tools.ietf.org/html/draft-irtf-cfrg-kdf-uses-00

https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki

secp256k1: (http://www.secg.org/sec2-v2.pdf)

https://kobl.one/blog/create-full-ethereum-keypair-and-address/#generating-the-ec-private-key

https://bitcoin.stackexchange.com/questions/62533/key-derivation-in-hd-wallets-using-the-extended-private-key-vs-hardened-derivati

https://bitcoin.stackexchange.com/questions/9202/why-does-bitcoin-use-two-hash-functions-sha-256-and-ripemd-160-to-create-an-ad/9216#9216

https://en.bitcoin.it/wiki/Wallet_import_format

ecdsa: https://www.cryptocompare.com/wallets/guides/how-do-digital-signatures-in-bitcoin-work/