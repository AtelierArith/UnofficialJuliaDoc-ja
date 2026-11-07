```julia
digest!(context)
```

Finalize the SHA context and return the hash as array of bytes (Vector{Uint8}). Updating the context after calling `digest!` on it will error.

# Examples

```julia-repl
julia> ctx = SHA1_CTX()
SHA1 hash state

julia> update!(ctx, b"data to to be hashed")

julia> digest!(ctx)
20-element Vector{UInt8}:
 0x83
 0xe4
 ⋮
 0x89
 0xf5

julia> update!(ctx, b"more data")
ERROR: Cannot update CTX after `digest!` has been called on it
[...]
```
