```julia
isunordered(x)
```

Return `true` if `x` is a value that is not orderable according to [`<`](@ref), such as `NaN` or `missing`.

The values that evaluate to `true` with this predicate may be orderable with respect to other orderings such as [`isless`](@ref).

!!! compat "Julia 1.7"
    This function requires Julia 1.7 or later.

