```julia
join_multicast_group(sock::UDPSocket, group_addr, interface_addr = nothing)
```

Join a socket to a particular multicast group defined by `group_addr`. If `interface_addr` is given, specifies a particular interface for multi-homed systems.  Use `leave_multicast_group()` to disable reception of a group.
