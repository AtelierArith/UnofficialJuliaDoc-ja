```julia
getaddrinfo(host::AbstractString, IPAddr) -> IPAddr
```

Gets the first IP address of the `host` of the specified `IPAddr` type. Uses the operating system's underlying getaddrinfo implementation, which may do a DNS lookup.

# Examples

```jldoctest; filter = r"(ip\"::1\"|ERROR: DNSError:.*|Stacktrace:(\n \[0-9]+\].*)*)"
julia> getaddrinfo("localhost", IPv6)
ip"::1"

julia> getaddrinfo("localhost", IPv4)
ip"127.0.0.1"
```
