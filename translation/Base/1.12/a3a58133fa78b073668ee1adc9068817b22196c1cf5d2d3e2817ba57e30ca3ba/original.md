```julia
mapfoldl(f, op, itr; [init])
```

Like [`mapreduce`](@ref), but with guaranteed left associativity, as in [`foldl`](@ref). If provided, the keyword argument `init` will be used exactly once. In general, it will be necessary to provide `init` to work with empty collections.
