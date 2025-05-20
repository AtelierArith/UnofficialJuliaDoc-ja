```
Core.memoryrefreplace!(::GenericMemoryRef, expected, desired,
                       success_order::Symbol, fail_order::Symbol=success_order, boundscheck::Bool) -> (; old, success::Bool)
```

Atomically perform the operations to get and conditionally set a `MemoryRef` value.

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.


See also [`replaceproperty!`](@ref Base.replaceproperty!) and [`Core.memoryrefset!`](@ref).
