```julia
last(coll)
```

Get the last element of an ordered collection, if it can be computed in O(1) time. This is accomplished by calling [`lastindex`](@ref) to get the last index. Return the end point of an [`AbstractRange`](@ref) even if it is empty.

See also [`first`](@ref), [`endswith`](@ref).

# Examples

```jldoctest
julia> last(1:2:10)
9

julia> last([1; 2; 3; 4])
4
```
