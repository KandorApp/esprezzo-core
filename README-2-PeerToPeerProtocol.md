# P2P Discovery Protocol Overview

Discovery achieved through a terse peer to peer tcp messaging protocol. The goal of this layer is to establish and maintain a map of network connections along with their state and connection status.

## Implemented Network Messages

- HELLO (announce)
  Upon Discovery each peer must send a HELLO message with the following data

  ```
  p2pVersion
  clientId
  listenPort
  nodeId
  ```

- PING (keepalive)
- PONG (keepalive)
- DISCONNECT (hangup)

## Additional P2P Messages to be added.
  - TCP sub-system error;
  - Useless peer;
  - Too many peers;
  - Incompatible P2P protocol version;
  - Null node identity received - this is automatically invalid;
  - Identity is the same as this node (i.e. connected to itself);
  - Timeout on receiving a message (i.e. nothing received since sending last ping);


## P2P/NodeIDs
- UUIDs are randomly generated when server starts.
