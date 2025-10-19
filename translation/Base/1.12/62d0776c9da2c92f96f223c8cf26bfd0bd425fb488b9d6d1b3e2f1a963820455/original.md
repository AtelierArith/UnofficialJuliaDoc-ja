```julia
intersect!(s::Union{AbstractSet,AbstractVector}, itrs...)
```

Intersect all passed in sets and overwrite `s` with the result. Maintain order with arrays.

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.

