```julia
atand(y::T) where T -> float(T)
atand(y::T, x::S) where {T,S} -> promote_type(T,S)
atand(y::AbstractMatrix{T}) where T -> AbstractMatrix{Complex{float(T)}}
```

Compute the inverse tangent of `y` or `y/x`, respectively, where the output is in degrees.

Return a `NaN` if `isnan(y)` or `isnan(x)`. The returned `NaN` is either a `T` in the single argument version, or a `promote_type(T,S)` in the two argument version.

!!! compat "Julia 1.7"
    The one-argument method supports square matrix arguments as of Julia 1.7.

