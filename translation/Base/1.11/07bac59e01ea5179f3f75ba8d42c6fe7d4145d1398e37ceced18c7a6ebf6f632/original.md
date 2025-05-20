```
first(coll)
```

Get the first element of an iterable collection. Return the start point of an [`AbstractRange`](@ref) even if it is empty.

See also: [`only`](@ref), [`firstindex`](@ref), [`last`](@ref).

# Examples

```jldoctest
julia> first(2:2:10)
2

julia> first([1; 2; 3; 4])
1
```
