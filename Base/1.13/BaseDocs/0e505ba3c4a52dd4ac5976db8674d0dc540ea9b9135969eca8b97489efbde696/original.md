```julia
.=
```

Perform broadcasted assignment. The right-side argument is expanded as in [`broadcast`](@ref) and then assigned into the left-side argument in-place. Fuses with other dotted operators in the same expression; i.e. the whole assignment expression is converted into a single loop.

`A .= B` is similar to `broadcast!(identity, A, B)`.

# Examples

```jldoctest
julia> A = zeros(4, 4); B = [1, 2, 3, 4];

julia> A .= B
4×4 Matrix{Float64}:
 1.0  1.0  1.0  1.0
 2.0  2.0  2.0  2.0
 3.0  3.0  3.0  3.0
 4.0  4.0  4.0  4.0

julia> A
4×4 Matrix{Float64}:
 1.0  1.0  1.0  1.0
 2.0  2.0  2.0  2.0
 3.0  3.0  3.0  3.0
 4.0  4.0  4.0  4.0
```
