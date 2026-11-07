```julia
map!(function, array)
```

Like [`map`](@ref), but stores the result in the same array.

!!! compat "Julia 1.12"
    This method requires Julia 1.12 or later. To support previous versions too, use the equivalent `map!(function, array, array)`.


# Examples

```jldoctest
julia> a = [1 2 3; 4 5 6];

julia> map!(x -> x^3, a);

julia> a
2×3 Matrix{Int64}:
  1    8   27
 64  125  216
```
