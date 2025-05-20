```
cumprod!(y::AbstractVector, x::AbstractVector)
```

Cumulative product of a vector `x`, storing the result in `y`. See also [`cumprod`](@ref).

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.

