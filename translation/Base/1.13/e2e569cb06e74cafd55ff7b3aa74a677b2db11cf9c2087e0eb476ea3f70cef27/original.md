```julia
wrap(Array, m::Union{Memory{T}, MemoryRef{T}}, dims)
```

Create an array of size `dims` using `m` as the underlying memory. This can be thought of as a safe version of [`unsafe_wrap`](@ref) utilizing `Memory` or `MemoryRef` instead of raw pointers.
