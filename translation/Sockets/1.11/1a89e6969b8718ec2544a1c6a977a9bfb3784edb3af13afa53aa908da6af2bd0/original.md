```julia
leave_multicast_group(sock::UDPSocket, group_addr, interface_addr = nothing)
```

Remove a socket from  a particular multicast group defined by `group_addr`. If `interface_addr` is given, specifies a particular interface for multi-homed systems.  Use `join_multicast_group()` to enable reception of a group.
