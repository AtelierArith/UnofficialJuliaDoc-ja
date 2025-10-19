```julia
sinc(x::T) where {T <: Number} -> float(T)
```

Compute normalized sinc function $\operatorname{sinc}(x) = \sin(\pi x) / (\pi x)$ if $x \neq 0$, and $1$ if $x = 0$.

Return a `T(NaN)` if `isnan(x)`.

See also [`cosc`](@ref), its derivative.
