```julia
tanpi(x::T) where T -> float(T)
```

Compute $\tan(\pi x)$ more accurately than `tan(pi*x)`, especially for large `x`.

Throw a [`DomainError`](@ref) if `isinf(x)`, return a `T(NaN)` if `isnan(x)`.

!!! compat "Julia 1.10"
    This function requires at least Julia 1.10.


See also [`tand`](@ref), [`sinpi`](@ref), [`cospi`](@ref), [`sincospi`](@ref).
