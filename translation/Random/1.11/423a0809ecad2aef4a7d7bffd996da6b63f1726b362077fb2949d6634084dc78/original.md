```julia
Random.hash_seed(seed, ctx::SHA_CTX)::AbstractVector{UInt8}
```

Update `ctx` via `SHA.update!` with the content of `seed`. This function is used by the [`SeedHasher`](@ref) RNG to produce random bytes.

`seed` can currently be of type `Union{Integer, AbstractString, AbstractArray{UInt32}, AbstractArray{UInt64}}`, but modules can extend this function for types they own.

`hash_seed` is "injective" : for two equivalent context objects `cn` and `cm`, if `n != m`, then `cn` and `cm` will be distinct after calling `hash_seed(n, cn); hash_seed(m, cm)`. Moreover, if `n == m`, then `cn` and `cm` remain equivalent after calling `hash_seed(n, cn); hash_seed(m, cm)`.
