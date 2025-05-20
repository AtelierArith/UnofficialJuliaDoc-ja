```
insorted(x, v; by=identity, lt=isless, rev=false) -> Bool
```

Determine whether a vector `v` contains any value equivalent to `x`. The vector `v` must be sorted according to the order defined by the keywords. Refer to [`sort!`](@ref) for the meaning of the keywords and the definition of equivalence. Note that the `by` function is applied to the searched value `x` as well as the values in `v`.

The check is generally done using binary search, but there are optimized implementations for some inputs.

See also [`in`](@ref).

# Examples

```jldoctest
julia> insorted(4, [1, 2, 4, 5, 5, 7]) # single match
true

julia> insorted(5, [1, 2, 4, 5, 5, 7]) # multiple matches
true

julia> insorted(3, [1, 2, 4, 5, 5, 7]) # no match
false

julia> insorted(9, [1, 2, 4, 5, 5, 7]) # no match
false

julia> insorted(0, [1, 2, 4, 5, 5, 7]) # no match
false

julia> insorted(2=>"TWO", [1=>"one", 2=>"two", 4=>"four"], by=first) # compare the keys of the pairs
true
```

!!! compat "Julia 1.6"
    `insorted` was added in Julia 1.6.

