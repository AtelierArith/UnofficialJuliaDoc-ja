```
UnitRange{T<:Real}
```

A range parameterized by a `start` and `stop` of type `T`, filled with elements spaced by `1` from `start` until `stop` is exceeded. The syntax `a:b` with `a` and `b` both `Integer`s creates a `UnitRange`.

# Examples

```jldoctest
julia> collect(UnitRange(2.3, 5.2))
3-element Vector{Float64}:
 2.3
 3.3
 4.3

julia> typeof(1:10)
UnitRange{Int64}
```
