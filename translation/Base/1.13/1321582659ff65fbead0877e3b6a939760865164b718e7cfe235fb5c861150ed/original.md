```julia
mapfoldr(f, op, itr; [init])
```

Like [`mapreduce`](@ref), but with guaranteed right associativity, as in [`foldr`](@ref). If provided, the keyword argument `init` will be used exactly once. In general, it will be necessary to provide `init` to work with empty collections.
