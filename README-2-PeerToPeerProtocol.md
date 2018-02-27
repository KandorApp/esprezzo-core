# P2P Discovery Protocol Overview

Discovery achieved through a terse peer to peer tcp messaging protocol. The goal of this layer is to establish and maintain a map of network connections along with their state and connection status.

## Implemented Network Messages

- HELLO
  Upon Discovery each peer must send a HELLO message with the follwoing data

  p2pVersion
  clientId
  listenPort
  nodeId

## Additional P2P Messages
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
- UUIDs are randomly generated when server starts.
