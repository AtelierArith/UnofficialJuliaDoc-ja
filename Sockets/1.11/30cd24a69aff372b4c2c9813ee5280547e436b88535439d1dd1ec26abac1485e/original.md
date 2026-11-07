```julia
getaddrinfo(host::AbstractString) -> IPAddr
```

Gets the first available IP address of `host`, which may be either an `IPv4` or `IPv6` address. Uses the operating system's underlying getaddrinfo implementation, which may do a DNS lookup.
