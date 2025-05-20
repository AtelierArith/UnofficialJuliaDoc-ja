```
searchsorted(v, x; by=identity, lt=isless, rev=false)
```

Return the range of indices in `v` where values are equivalent to `x`, or an empty range located at the insertion point if `v` does not contain values equivalent to `x`. The vector `v` must be sorted according to the order defined by the keywords. Refer to [`sort!`](@ref) for the meaning of the keywords and the definition of equivalence. Note that the `by` function is applied to the searched value `x` as well as the values in `v`.

The range is generally found using binary search, but there are optimized implementations for some inputs.

See also: [`searchsortedfirst`](@ref), [`sort!`](@ref), [`insorted`](@ref), [`findall`](@ref).

# Examples

```jldoctest
julia> searchsorted([1, 2, 4, 5, 5, 7], 4) # single match
3:3

julia> searchsorted([1, 2, 4, 5, 5, 7], 5) # multiple matches
4:5

julia> searchsorted([1, 2, 4, 5, 5, 7], 3) # no match, insert in the middle
3:2

julia> searchsorted([1, 2, 4, 5, 5, 7], 9) # no match, insert at end
7:6

julia> searchsorted([1, 2, 4, 5, 5, 7], 0) # no match, insert at start
1:0

julia> searchsorted([1=>"one", 2=>"two", 2=>"two", 4=>"four"], 2=>"two", by=first) # compare the keys of the pairs
2:3
```
