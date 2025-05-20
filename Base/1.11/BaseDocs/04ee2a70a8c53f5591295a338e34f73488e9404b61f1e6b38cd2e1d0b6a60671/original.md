```
Core.memoryref_isassigned(::GenericMemoryRef, ordering::Symbol, boundscheck::Bool)
```

Return whether there is a value stored at the `MemoryRef`, returning false if the `Memory` is empty. See [`isassigned(::Base.RefValue)`](@ref), [`Core.memoryrefget`](@ref). The memory ordering specified must be compatible with the `isatomic` parameter.

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.

