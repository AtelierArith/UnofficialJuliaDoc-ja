```julia
replaceglobal!(module::Module, name::Symbol, expected, desired,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> (; old, success::Bool)
```

Atomically perform the operations to get and conditionally set a global to a given value.

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.


See also [`replaceproperty!`](@ref Base.replaceproperty!) and [`setglobal!`](@ref).
