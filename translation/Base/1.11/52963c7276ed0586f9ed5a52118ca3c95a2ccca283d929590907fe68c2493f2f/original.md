```
methods(f, [types], [module])
```

Return the method table for `f`.

If `types` is specified, return an array of methods whose types match. If `module` is specified, return an array of methods defined in that module. A list of modules can also be specified as an array.

!!! compat "Julia 1.4"
    At least Julia 1.4 is required for specifying a module.


See also: [`which`](@ref), [`@which`](@ref Main.InteractiveUtils.@which) and [`methodswith`](@ref Main.InteractiveUtils.methodswith).
