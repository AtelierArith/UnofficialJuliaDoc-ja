```julia
sind(x::T) where T -> float(T)
```

Compute sine of `x`, where `x` is in degrees. If `x` is a matrix, `x` needs to be a square matrix.

Throw a [`DomainError`](@ref) if `isinf(x)`, return a `T(NaN)` if `isnan(x)`.

!!! compat "Julia 1.7"
    Matrix arguments require Julia 1.7 or later.

