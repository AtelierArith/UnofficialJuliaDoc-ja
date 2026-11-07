```julia
coth(x::T) where {T <: Number} -> float(T)
```

Compute the hyperbolic cotangent of `x`.

Return a `T(NaN)` if `isnan(x)`.
