```julia
widemul(x, y)
```

Multiply `x` and `y`, giving the result as a larger type.

See also [`promote`](@ref), [`Base.add_sum`](@ref).

# Examples

```jldoctest
julia> widemul(Float32(3.0), 4.0) isa BigFloat
true

julia> typemax(Int8) * typemax(Int8)
1

julia> widemul(typemax(Int8), typemax(Int8))  # == 127^2
16129
```
