```
swapglobal!(module::Module, name::Symbol, x, [order::Symbol=:monotonic])
```

Atomically perform the operations to simultaneously get and set a global.

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.


See also [`swapproperty!`](@ref Base.swapproperty!) and [`setglobal!`](@ref).
