```julia
zero(x)
zero(::Type)
```

Get the additive identity element for `x`. If the additive identity can be deduced from the type alone, then a type may be given as an argument to `zero`.

For example, `zero(Int)` will work because the additive identity is the same for all instances of `Int`, but `zero(Vector{Int})` is not defined because vectors of different lengths have different additive identities.

See also [`iszero`](@ref), [`one`](@ref), [`oneunit`](@ref), [`oftype`](@ref).

# Examples

```jldoctest
julia> zero(1)
0

julia> zero(big"2.0")
0.0

julia> zero(rand(2,2))
2×2 Matrix{Float64}:
 0.0  0.0
 0.0  0.0
```
