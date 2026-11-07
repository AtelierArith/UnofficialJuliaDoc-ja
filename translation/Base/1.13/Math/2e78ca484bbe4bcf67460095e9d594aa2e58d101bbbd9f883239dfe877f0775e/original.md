```julia
sincospi(x::T) where T -> Tuple{float(T),float(T)}
```

Simultaneously compute [`sinpi(x)`](@ref) and [`cospi(x)`](@ref) (the sine and cosine of `π*x`, where `x` is in radians), returning a tuple `(sine, cosine)`.

Throw a [`DomainError`](@ref) if `isinf(x)`, return a `(T(NaN), T(NaN))` tuple if `isnan(x)`.

!!! compat "Julia 1.6"
    This function requires Julia 1.6 or later.


See also: [`cispi`](@ref), [`sincosd`](@ref), [`sinpi`](@ref).
