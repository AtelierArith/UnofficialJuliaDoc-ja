```
circshift!(a::AbstractVector, shift::Integer)
```

Circularly shift, or rotate, the data in vector `a` by `shift` positions.

# Examples

```jldoctest
julia> circshift!([1, 2, 3, 4, 5], 2)
5-element Vector{Int64}:
 4
 5
 1
 2
 3

julia> circshift!([1, 2, 3, 4, 5], -2)
5-element Vector{Int64}:
 3
 4
 5
 1
 2
```
