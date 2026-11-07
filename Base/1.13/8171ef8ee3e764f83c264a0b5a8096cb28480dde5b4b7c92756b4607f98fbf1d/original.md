```julia
cumprod!(B, A; dims::Integer)
```

Cumulative product of `A` along the dimension `dims`, storing the result in `B`. See also [`cumprod`](@ref).

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.

