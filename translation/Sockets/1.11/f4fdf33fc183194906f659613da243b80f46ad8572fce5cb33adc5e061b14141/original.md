```
setopt(sock::UDPSocket; multicast_loop=nothing, multicast_ttl=nothing, enable_broadcast=nothing, ttl=nothing)
```

Set UDP socket options.

  * `multicast_loop`: loopback for multicast packets (default: `true`).
  * `multicast_ttl`: TTL for multicast packets (default: `nothing`).
  * `enable_broadcast`: flag must be set to `true` if socket will be used for broadcast messages, or else the UDP system will return an access error (default: `false`).
  * `ttl`: Time-to-live of packets sent on the socket (default: `nothing`).
