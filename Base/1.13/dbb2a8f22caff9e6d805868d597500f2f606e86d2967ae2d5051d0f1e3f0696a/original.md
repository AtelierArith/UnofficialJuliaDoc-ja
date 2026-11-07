```julia
get_world_counter()
```

Returns the current maximum world-age counter. This counter is monotonically increasing.

!!! warning
    This counter is global and may change at any time between invocations. In general, most reflection functions operate on the current task's world age, rather than the global maximum world age. See [`tls_world_age`](@ref) as well as the [manual chapter of world age](@ref man-world-age).

