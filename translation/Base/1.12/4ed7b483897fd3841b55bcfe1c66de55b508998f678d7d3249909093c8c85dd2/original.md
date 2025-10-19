```julia
complex(r, [i])
```

Convert real numbers or arrays to complex. `i` defaults to zero.

# Examples

```jldoctest
julia> complex(7)
7 + 0im

julia> complex([1, 2, 3])
3-element Vector{Complex{Int64}}:
 1 + 0im
 2 + 0im
 3 + 0im
```
