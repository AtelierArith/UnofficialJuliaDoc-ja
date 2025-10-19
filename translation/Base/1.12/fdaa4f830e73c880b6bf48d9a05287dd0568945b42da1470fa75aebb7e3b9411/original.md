```julia
pushfirst!(collection, items...) -> collection
```

Insert one or more `items` at the beginning of `collection`.

This function is called `unshift` in many other programming languages.

# Examples

```jldoctest
julia> pushfirst!([1, 2, 3, 4], 5, 6)
6-element Vector{Int64}:
 5
 6
 1
 2
 3
 4
```
