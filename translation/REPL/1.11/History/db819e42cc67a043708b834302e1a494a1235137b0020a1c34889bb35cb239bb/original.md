```julia
addcache!(cache::Vector{T}, state::Unsigned, new::T)
```

Add `new` to the log-structured `cache` according to `state`.

The lifetime of `new` is exponentially decaying, it has a `1` in `2^(k-1)` chance of reaching the `k`-th position in the cache.

The cache can hold as many items as the number of bits in `state` (e.g. 8 for `UInt8`).
