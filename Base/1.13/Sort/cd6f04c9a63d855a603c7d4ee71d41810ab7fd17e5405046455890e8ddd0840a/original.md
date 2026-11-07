```julia
make_scratch(scratch::Union{Nothing, Vector}, T::Type, len::Integer)
```

Returns `(s, t)` where `t` is an `AbstractVector` of type `T` with length at least `len` that is backed by the `Vector` `s`. If `scratch !== nothing`, then `s === scratch`.

This function will allocate a new vector if `scratch === nothing`, `resize!` `scratch` if it is too short, and `reinterpret` `scratch` if its eltype is not `T`.
