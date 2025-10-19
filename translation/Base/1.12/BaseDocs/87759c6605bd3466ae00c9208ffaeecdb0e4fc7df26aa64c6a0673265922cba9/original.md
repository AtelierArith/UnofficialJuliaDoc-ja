```julia
modifyglobal!(module::Module, name::Symbol, op, x, [order::Symbol=:monotonic]) -> Pair
```

Atomically perform the operations to get and set a global after applying the function `op`.

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.


See also [`modifyproperty!`](@ref Base.modifyproperty!) and [`setglobal!`](@ref).
