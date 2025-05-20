```
Core.memoryrefswap!(::GenericMemoryRef, value, ordering::Symbol, boundscheck::Bool)
```

Atomically perform the operations to simultaneously get and set a `MemoryRef` value.

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.


See also [`swapproperty!`](@ref Base.swapproperty!) and [`Core.memoryrefset!`](@ref).
