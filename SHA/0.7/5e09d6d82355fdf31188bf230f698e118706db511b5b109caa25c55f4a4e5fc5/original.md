```
update!(context, data[, datalen])
```

Update the SHA context with the bytes in data. See also [`digest!`](@ref) for finalizing the hash.

# Examples

```julia-repl
julia> ctx = SHA1_CTX()
SHA1 hash state

julia> update!(ctx, b"data to to be hashed")
```
