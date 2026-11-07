```julia
Base.unalias(dest, A)
```

Return either `A` or a copy of `A` in a rough effort to prevent modifications to `dest` from affecting the returned object. No guarantees are provided.

Custom arrays that wrap or use fields containing arrays that might alias against other external objects should provide a [`Base.dataids`](@ref) implementation.

This function must return an object of exactly the same type as `A` for performance and type stability. Mutable custom arrays for which [`copy(A)`](@ref) is not `typeof(A)` should provide a [`Base.unaliascopy`](@ref) implementation.

See also [`Base.mightalias`](@ref).
