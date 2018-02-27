# Technical FAQ

## What are "Sidechains" in EsprezzoCore?
We use the term “sidechain” to describe dataset(s) stored in parallel to our main ledger. They share nearly the same Merkle Trie/Tree datastructure as the core ledger but with a schema that lends itself to storing unstructured data where the core ledger is focused on settlements/payments. I have seen this term used loosely to describe ancillary datasets that are not committed to the main ledger but may interact with it. At this point, if this term ends up seeming misleading or inaccurate we can discuss its use, but I think it implies a domain specific dataset stored in a blockchain/Merkle Tree structure that is individual from the main ledger and therefore can be expired or “pruned”.

## What is the benefit of "Light Proof of Work"?
Currently when a node is elected to forge a block, they run a very low difficulty Proof of Work cycle to create a block candidate using the same nonce-based iterative process seen in standard Proof of Work systems. There is a lot of work to be done in this area so this may change before the first public release, but I like the idea of adding a little computational difficulty/physical limitation to the forging process.

## What hardware do you target to run a full node? 
There are several dependency requirements to run a full node. Erlang/OTP, Elixir, a Rust compiler, PostgresSQL and enough RAM and disk storage to hold the blockchain fabric(core and sidechain ledgers) and metadata. Increasingly, parts of the codebase are being implemented in Rust with the goal of having a pure rust version that holds only the core ledger. This would be relevant for the lowest tier of "Full Node". This will have fewer dependencies and require less memory and disk space while still being useful to the network. In theory I could see this running well on a laptop or Rasberry Pi. The idea is that highest order full nodes will be required to store all active sidechains and as such will require more resources. I think something near a 4-8 core VPS with 64 GB of RAM is a conservative baseline to support a first-tier public full node.

## Cloud providers often prohibit mining operations, but "low difficulty" may be tolerated.
I have only seen/heard of this with Google Compute Cloud and my experience experimenting with Azure and AWS has been quite the opposite. In any case, our "Light Proof of Work" is totally CPU based and a blip of resource consumption compared to full Proof of Work systems.


## Is there reward for forging blocks or do forgers only earn transaction fees?
All coins will be issued at the genesis block. Rewards will come only from transaction fees. The weighting system will give a forger an added bonus but not on the level of Bitcoin or other coin producing block generation models.

## How do transaction fees scale with user growth? BTC and others have higher fees as more users compete to use the blockchain, but a scalable system could lower fees as the volume of transactions increases.(scalability and equilibrium)
Keep in mind that transaction fees apply not only to economic transactions but more importantly, to developers and companies using the middleware data delivery layer to host fault tolerant, globally distributed application datasets. This should create increasing rewards for stakeholders based on demand for network services.

Transaction fees will be prioritized by value and priority can be set by the txn creator by offering to pay a higher fee. This should be market driven but our target throughput should have the effect of creating very little competition for near instant transactions as we are not waiting for long PoW block times and support a relatively large block size. Additionally, we are favoring an account based model as seen in Ethereum over a UTXO model as seen in other cryptocurrencies. This helps reduce the massive block sizes that result from grouping large numbers of UTXOs as well as the resulting "change" txns in an effort to create the desired resulting txn inputs(payments).

Staking election is weighted positively both by the number of coins staked, and the length of time for which they are voluntarily locked/taken out of circulation. This creates scarcity which must be managed. That is addressed below. A forger gets a premium for winning a staking lottery but that is only one factor in how the sum of the fees is distrubuted at the end of an "epoch" or [payment cycle which is determined simply by the forging of (n)blocks]

As all coins have been mined at the genesis block, it could be argued that if the profit incentives that excessivly reward behavior leading to low liquidity are not managed, the system could easily trend towards a deflationary environment that would further incentivize hoarding, causing a general slowdown in the economy. One possible solution to this is that this decreased usage or "hoarding" should result in lower transaction payouts which will reduce the incentive to lock coins and correct towards increased liquididy. This should also lead to an equilibrium seeking response to variable demand based on the actual utility of the network and will theoretically create thresholds on either side of the liquidity spectrum where varable compression can be applied by making small changes to the rewards ratios over time.
 
Much more thought and experimentation is needed here. This will evolve over time with the goals of creating the right balance of incentives and rewards. At the end of the day this is a utility token and the demand for system/network resources will ultimately be the determining factor in the economic success, value and longevity of the token.  

## 50,000 tokens (EZP?) to be a delegate/masternode. 
50k+ is the current estimate for minimum tokens required to apply for delegate status. If you stake and maintain delegate status long term, you will also be moving towards higher tiers by earning fractional rewards from your constituent stakers. I like the EZP Symbol idea as ESP is taken :-) 

## How many delegates do we want?
This is still being considered. Presently we would like to reach and sustain 100 masternodes or nodes that stake enough tokens to qualify for delegate status and adequate resources to host the entire chain fabric. Performance and uptime of delegates will also be a primary factor in their ongoing selection and ability to apply for selection as a delegate.

## How many entities will be incentivized to be a delegate even if validating transactions is not directly profitable?
Validating transactions is directly profitable, but this will only be done by delegates that are voted in by the community and only if they have sufficient stake to apply.

## Is there a finite token supply? 
Yes. 500MM.

## What percentage of that is the lowest staking tier (50,000)?
0.01%

## How easy will it be to buy 50,000 tokens?
That is fairly subjective but the goal of the ICO is to make it as accessible as possible for the early adoptors that see the same potential that we do.

## How easy will it be to run masternode software on AWS
We already have an remote node configuration and deployment system as part of the core app. It allows you to add ip addresses and ssh identities to remotely install dependencies, deploy and update the app on any number of remote machines(currently only Ubuntu 16x) that are configured to allow non-password key-based ssh login. This will continue to evolve with the goal of easily managing any number of nodes from a central clone of our github repo.

Even by selecting a delegate and staking from a desktop wallet, a large stakeholder should be able to earn a nice reward even if they dont run a masternode. They will however, be missing out on an even higher reward. This should be noticeable enough to incentivize them to put in the effort to run a public masternode and support the network.

## How profitable will that be?
This is undetermined and will be based on the success of the network. As we test we should be able to make increasingly informed and accurate predictions.




