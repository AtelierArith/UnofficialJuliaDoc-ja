```
hash_seed(seed) -> AbstractVector{UInt8}
```

Return a cryptographic hash of `seed` of size 256 bits (32 bytes). `seed` can currently be of type `Union{Integer, AbstractString, AbstractArray{UInt32}, AbstractArray{UInt64}}`, but modules can extend this function for types they own.

`hash_seed` is "injective" : if `n != m`, then `hash_seed(n) !=`hash*seed(m)`. Moreover, if`n == m`, then`hash*seed(n) == hash_seed(m)`.

This is an internal function subject to change.
