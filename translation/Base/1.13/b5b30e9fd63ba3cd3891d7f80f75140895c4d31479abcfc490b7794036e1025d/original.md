```julia
setindex(t::Tuple, v, i::Integer)
```

Creates a new tuple similar to `t` with the value at index `i` set to `v`. Throws a `BoundsError` when out of bounds.

# Examples

```jldoctest
julia> Base.setindex((1, 2, 6), 2, 3) == (1, 2, 2)
true
```
