```julia
BottomRF(rf) -> rf′
```

"Bottom" reducing function.  This is a thin wrapper around the `op` argument passed to `foldl`-like functions for handling the initial invocation to call [`reduce_first`](@ref).
