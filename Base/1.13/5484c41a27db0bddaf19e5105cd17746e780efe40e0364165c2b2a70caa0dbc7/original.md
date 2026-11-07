```julia
cumsum!(B, A; dims::Integer)
```

Cumulative sum of `A` along the dimension `dims`, storing the result in `B`. See also [`cumsum`](@ref).

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.

