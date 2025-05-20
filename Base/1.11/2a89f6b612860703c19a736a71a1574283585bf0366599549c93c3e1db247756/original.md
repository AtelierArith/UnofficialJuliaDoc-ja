```
last(itr, n::Integer)
```

Get the last `n` elements of the iterable collection `itr`, or fewer elements if `itr` is not long enough.

!!! compat "Julia 1.6"
    This method requires at least Julia 1.6.


# Examples

```jldoctest
julia> last(["foo", "bar", "qux"], 2)
2-element Vector{String}:
 "bar"
 "qux"

julia> last(1:6, 10)
1:6

julia> last(Float64[], 1)
Float64[]
```
