```
SHA
```

The SHA module provides hashing functionality for SHA1, SHA2 and SHA3 algorithms.

They are implemented as both pure functions for hashing single pieces of data, or a stateful context which can be updated with the `update!` function and finalized with `digest!`.

```julia-repl julia> sha1(b"some data") 20-element Vector{UInt8}:  0xba  0xf3     ⋮  0xe3  0x56

julia> ctx = SHA1_CTX() SHA1 hash state

julia> update!(ctx, b"some data") 0x0000000000000009

julia> digest!(ctx) 20-element Vector{UInt8}:  0xba  0xf3     ⋮  0xe3  0x56
