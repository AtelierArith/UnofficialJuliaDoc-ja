```julia
sincos(x::T) where T -> Tuple{float(T),float(T)}
```

Simultaneously compute the sine and cosine of `x`, where `x` is in radians, returning a tuple `(sine, cosine)`.

Throw a [`DomainError`](@ref) if `isinf(x)`, return a `(T(NaN), T(NaN))` if `isnan(x)`.

See also [`cis`](@ref), [`sincospi`](@ref), [`sincosd`](@ref).
