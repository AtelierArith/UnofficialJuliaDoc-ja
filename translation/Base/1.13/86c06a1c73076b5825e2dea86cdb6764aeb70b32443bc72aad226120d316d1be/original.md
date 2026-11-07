```julia
Base.reduce_empty(op, T)
```

The value to be returned when calling [`reduce`](@ref), [`foldl`](@ref) or [`foldr`](@ref) with reduction `op` over an empty array with element type of `T`.

This should only be defined in unambiguous cases; for example,

```julia
Base.reduce_empty(::typeof(+), ::Type{T}) where T = zero(T)
```

is justified (the sum of zero elements is zero), whereas `reduce_empty(::typeof(max), ::Type{Any})` is not (the maximum value of an empty collection is generally ambiguous, and especially so when the element type is unknown).

As an alternative, consider supplying an `init` value to the reducer.
