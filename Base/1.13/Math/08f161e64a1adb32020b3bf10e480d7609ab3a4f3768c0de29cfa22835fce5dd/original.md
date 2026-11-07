```julia
asin(x::T) where {T <: Number} -> float(T)
```

Compute the inverse sine of `x`, where the output is in radians.

Return a `T(NaN)` if `isnan(x)`.

See also [`asind`](@ref) for output in degrees.

# Examples

```jldoctest
julia> asin.((0, 1/2, 1))
(0.0, 0.5235987755982989, 1.5707963267948966)

julia> asind.((0, 1/2, 1))
(0.0, 30.000000000000004, 90.0)
```
