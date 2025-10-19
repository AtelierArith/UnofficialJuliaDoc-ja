```julia
acos(x::T) where {T <: Number} -> float(T)
```

Compute the inverse cosine of `x`, where the output is in radians

Return a `T(NaN)` if `isnan(x)`.
