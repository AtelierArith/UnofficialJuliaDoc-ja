```julia
cospi(x::T) where T -> float(T)
```

Compute $\cos(\pi x)$ more accurately than `cos(pi*x)`, especially for large `x`.

Throw a [`DomainError`](@ref) if `isinf(x)`, return a `T(NaN)` if `isnan(x)`.

See also: [`cispi`](@ref), [`sincosd`](@ref), [`cospi`](@ref).
