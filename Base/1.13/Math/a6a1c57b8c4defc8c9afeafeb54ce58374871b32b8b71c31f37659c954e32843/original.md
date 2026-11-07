```julia
sincosd(x::T) where T -> Tuple{float(T),float(T)}
```

Simultaneously compute the sine and cosine of `x`, where `x` is in degrees, returning a tuple `(sine, cosine)`.

Throw a [`DomainError`](@ref) if `isinf(x)`, return a `(T(NaN), T(NaN))` tuple if `isnan(x)`.

!!! compat "Julia 1.3"
    This function requires at least Julia 1.3.

