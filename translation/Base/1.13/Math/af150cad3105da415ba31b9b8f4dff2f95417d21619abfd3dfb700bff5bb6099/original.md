```julia
cos(x::T) where {T <: Number} -> float(T)
```

Compute cosine of `x`, where `x` is in radians.

Throw a [`DomainError`](@ref) if `isinf(x)`, return a `T(NaN)` if `isnan(x)`.

See also [`cosd`](@ref), [`cospi`](@ref), [`sincos`](@ref), [`cis`](@ref).
