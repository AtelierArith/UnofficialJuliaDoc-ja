```julia
flush(io::IO)
```

Commit all currently buffered writes to the given io. This has a default implementation `flush(::IO) = nothing`, so may be called in generic IO code.
