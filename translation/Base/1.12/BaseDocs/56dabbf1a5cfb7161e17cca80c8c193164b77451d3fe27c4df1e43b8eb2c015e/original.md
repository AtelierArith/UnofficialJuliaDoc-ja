```julia
Core.memoryrefsetonce!(::GenericMemoryRef, value,
                       success_order::Symbol, fail_order::Symbol=success_order, boundscheck::Bool) -> success::Bool
```

Atomically perform the operations to set a `MemoryRef` to a given value, only if it was previously not set.

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.


See also [`setpropertyonce!`](@ref Base.replaceproperty!) and [`Core.memoryrefset!`](@ref).
