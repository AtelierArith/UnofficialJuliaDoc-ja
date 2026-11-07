```julia
circshift!(dest, src, shifts)
```

Circularly shift, i.e. rotate, the data in `src`, storing the result in `dest`. `shifts` specifies the amount to shift in each dimension.

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.


See also [`circshift`](@ref).
