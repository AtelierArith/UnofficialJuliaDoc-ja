```julia
isassigned(v::Tuple, i::Integer) -> Bool
```

Return `true` if index `i` is within the bounds of tuple `v`, i.e. `1 ≤ i ≤ length(v)`.

!!! compat "Julia 1.13"
    This method requires at least Julia 1.13.

