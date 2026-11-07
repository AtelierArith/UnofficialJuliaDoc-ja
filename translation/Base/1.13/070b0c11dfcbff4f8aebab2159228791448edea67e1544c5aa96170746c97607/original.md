```julia
Base.unaliascopy(A)
```

Make a preventative copy of `A` in an operation where `A` [`Base.mightalias`](@ref) against another array in order to preserve consistent semantics as that other array is mutated.

This must return an object of the same type as `A` to preserve optimal performance in the much more common case where aliasing does not occur. By default, `unaliascopy(A::AbstractArray)` will attempt to use [`copy(A)`](@ref), but in cases where `copy(A)` is not a `typeof(A)`, then the array should provide a custom implementation of `Base.unaliascopy(A)`.
