```julia
Base.hasfastin(T)
```

Determine whether the computation `x ∈ collection` where `collection::T` can be considered as a "fast" operation (typically constant or logarithmic complexity). The definition `hasfastin(x) = hasfastin(typeof(x))` is provided for convenience so that instances can be passed instead of types. However the form that accepts a type argument should be defined for new types.

The default for `hasfastin(T)` is `true` for subtypes of [`AbstractSet`](@ref), [`AbstractDict`](@ref) and [`AbstractRange`](@ref) and `false` otherwise.
