```julia
sech(x::T) where {T <: Number} -> float(T)
```

Compute the hyperbolic secant of `x`.

Return a `T(NaN)` if `isnan(x)`.
