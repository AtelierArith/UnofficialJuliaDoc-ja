```julia
cosc(x::T) where {T <: Number} -> float(T)
```

Compute $\cos(\pi x) / x - \sin(\pi x) / (\pi x^2)$ if $x \neq 0$, and $0$ if $x = 0$. This is the derivative of `sinc(x)`.

Return a `T(NaN)` if `isnan(x)`.

See also [`sinc`](@ref).
