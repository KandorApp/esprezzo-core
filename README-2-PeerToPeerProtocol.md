# P2P Discovery Protocol Overview

Discovery achieved through a terse peer to peer tcp messaging protocol. The goal of this layer is to establish and maintain a map of network connections along with their state and connection status.

### Application handshake Protocol
Upon Discovery each peer must send a HELLO message with the follwoing data
### HELLO
  p2pVersion
  clientId
  listenPort
  nodeId

#RLP 
Disconnect can be requested at any time by either peer
### DISCONNECT
  0x00 Disconnect requested;
  0x01 TCP sub-system error;
  0x02 Breach of protocol, e.g. a malformed message, bad RLP, incorrect magic number &c.;
  0x03 Useless peer;
  0x04 Too many peers;
  0x05 Already connected;
  0x06 Incompatible P2P protocol version;
  0x07 Null node identity received - this is automatically invalid;
  0x08 Client quitting;
  0x09 Unexpected identity (i.e. a different identity to a previous connection/what a trusted peer told us).
  0x0a Identity is the same as this node (i.e. connected to itself);
  0x0b Timeout on receiving a message (i.e. nothing received since sending last ping);
  0x10 Some other reason specific to a subprotocol.



## P2P/NodeIDs
- Randomly generated UUID

## Data Transfer Protocol


Should we add enode ids?
How do NodeIDs work?
New Each time Node Starts
Old NodeIDs expire after ... 1 hr?
3 bad pings // removed from active
set "my ip" and avoid it for connections and pings
-OR-
compare node_uuids with connection return since "my_ip" will not be avail on the local iface

NEXT
send HELLO and compare versions.. if OK then add to PeerManager.authorized_peers
authorized_peers should be checked before each actions besides CONNECT and HELLO

Get timestamps right so connected_peers that are not authorized_peers after 1 minute are disconnected

make sure hanging conditions are safe

DIG up Credo

get elixir 1.6 with code formatting... ugh