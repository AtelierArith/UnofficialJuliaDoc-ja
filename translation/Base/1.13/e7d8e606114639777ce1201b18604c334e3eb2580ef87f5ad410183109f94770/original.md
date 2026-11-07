```julia
Base.mapreduce_empty(f, op, T)
```

The value to be returned when calling [`mapreduce`](@ref), [`mapfoldl`](@ref) or [`mapfoldr`](@ref) with map `f` and reduction `op` over an empty array with element type of `T`. See [`Base.reduce_empty`](@ref) for more information.
