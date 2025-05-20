```
Core.memoryrefmodify!(::GenericMemoryRef, op, value, ordering::Symbol, boundscheck::Bool) -> Pair
```

Atomically perform the operations to get and set a `MemoryRef` value after applying the function `op`.

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.


See also [`modifyproperty!`](@ref Base.modifyproperty!) and [`Core.memoryrefset!`](@ref).
