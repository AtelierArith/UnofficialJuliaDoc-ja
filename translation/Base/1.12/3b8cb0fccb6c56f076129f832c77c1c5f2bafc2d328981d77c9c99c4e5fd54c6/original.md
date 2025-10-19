```julia
first(itr, n::Integer)
```

Get the first `n` elements of the iterable collection `itr`, or fewer elements if `itr` is not long enough.

See also: [`startswith`](@ref), [`Iterators.take`](@ref).

!!! compat "Julia 1.6"
    This method requires at least Julia 1.6.


# Examples

```jldoctest
julia> first(["foo", "bar", "qux"], 2)
2-element Vector{String}:
 "foo"
 "bar"

julia> first(1:6, 10)
1:6

julia> first(Bool[], 1)
Bool[]
```
