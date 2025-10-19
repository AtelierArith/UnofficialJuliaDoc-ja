```julia
Core.memoryrefget(::GenericMemoryRef, ordering::Symbol, boundscheck::Bool)
```

Return the value stored at the `MemoryRef`, throwing a `BoundsError` if the `Memory` is empty. See `ref[]`. The memory ordering specified must be compatible with the `isatomic` parameter.

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.

