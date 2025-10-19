```julia
signbit(x)
```

Return `true` if the value of the sign of `x` is negative, otherwise `false`.

See also [`sign`](@ref) and [`copysign`](@ref).

# Examples

```jldoctest
julia> signbit(-4)
true

julia> signbit(5)
false

julia> signbit(5.5)
false

julia> signbit(-4.1)
true
```
