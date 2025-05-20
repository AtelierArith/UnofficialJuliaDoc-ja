```
Core.memoryrefset!(::GenericMemoryRef, value, ordering::Symbol, boundscheck::Bool)
```

Store the value to the `MemoryRef`, throwing a `BoundsError` if the `Memory` is empty. See `ref[] = value`. The memory ordering specified must be compatible with the `isatomic` parameter.

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.

