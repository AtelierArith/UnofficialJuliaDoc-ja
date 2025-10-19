```julia
csc(x::T) where {T <: Number} -> float(T)
```

Compute the cosecant of `x`, where `x` is in radians.

Throw a [`DomainError`](@ref) if `isinf(x)`, return a `T(NaN)` if `isnan(x)`.
