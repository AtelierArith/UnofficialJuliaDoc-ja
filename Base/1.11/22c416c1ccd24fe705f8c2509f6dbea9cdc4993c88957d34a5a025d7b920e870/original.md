```
mod1(x, y)
```

Modulus after flooring division, returning a value `r` such that `mod(r, y) == mod(x, y)` in the range $(0, y]$ for positive `y` and in the range $[y,0)$ for negative `y`.

With integer arguments and positive `y`, this is equal to `mod(x, 1:y)`, and hence natural for 1-based indexing. By comparison, `mod(x, y) == mod(x, 0:y-1)` is natural for computations with offsets or strides.

See also [`mod`](@ref), [`fld1`](@ref), [`fldmod1`](@ref).

# Examples

```jldoctest
julia> mod1(4, 2)
2

julia> mod1.(-5:5, 3)'
1×11 adjoint(::Vector{Int64}) with eltype Int64:
 1  2  3  1  2  3  1  2  3  1  2

julia> mod1.([-0.1, 0, 0.1, 1, 2, 2.9, 3, 3.1]', 3)
1×8 Matrix{Float64}:
 2.9  3.0  0.1  1.0  2.0  2.9  3.0  0.1
```
