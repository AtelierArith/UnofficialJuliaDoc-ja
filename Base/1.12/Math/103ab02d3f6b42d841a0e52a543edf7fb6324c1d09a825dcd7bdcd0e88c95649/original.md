```julia
sinpi(x::T) where T -> float(T)
```

Compute $\sin(\pi x)$ more accurately than `sin(pi*x)`, especially for large `x`.

Throw a [`DomainError`](@ref) if `isinf(x)`, return a `T(NaN)` if `isnan(x)`.

See also [`sind`](@ref), [`cospi`](@ref), [`sincospi`](@ref).
