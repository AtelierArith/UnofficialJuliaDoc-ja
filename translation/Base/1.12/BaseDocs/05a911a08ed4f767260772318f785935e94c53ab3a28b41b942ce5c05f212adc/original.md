```julia
setglobalonce!(module::Module, name::Symbol, value,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> success::Bool
```

Atomically perform the operations to set a global to a given value, only if it was previously not set.

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.


See also [`setpropertyonce!`](@ref Base.setpropertyonce!) and [`setglobal!`](@ref).
