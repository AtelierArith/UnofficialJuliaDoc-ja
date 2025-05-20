```
setproperty!(value, name::Symbol, x)
setproperty!(value, name::Symbol, x, order::Symbol)
```

The syntax `a.b = c` calls `setproperty!(a, :b, c)`. The syntax `@atomic order a.b = c` calls `setproperty!(a, :b, c, :order)` and the syntax `@atomic a.b = c` calls `setproperty!(a, :b, c, :sequentially_consistent)`.

!!! compat "Julia 1.8"
    `setproperty!` on modules requires at least Julia 1.8.


See also [`setfield!`](@ref Core.setfield!), [`propertynames`](@ref Base.propertynames) and [`getproperty`](@ref Base.getproperty).
