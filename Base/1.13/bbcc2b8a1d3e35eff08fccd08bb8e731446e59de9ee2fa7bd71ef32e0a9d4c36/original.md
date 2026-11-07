```julia
require_one_based_indexing(A::AbstractArray)
require_one_based_indexing(A,B...)
```

Throw an `ArgumentError` if the indices of any argument start with something other than `1` along any axis. See also [`has_offset_axes`](@ref).

!!! compat "Julia 1.2"
    This function requires at least Julia 1.2.

