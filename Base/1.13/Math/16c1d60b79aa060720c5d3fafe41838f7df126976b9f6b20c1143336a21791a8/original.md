```julia
csch(x::T) where {T <: Number} -> float(T)
```

Compute the hyperbolic cosecant of `x`.

Return a `T(NaN)` if `isnan(x)`.
