```julia
declare_global(module::Module, name::Symbol, strong::Bool=false, [ty::Type])
```

Declare the global `name` in module `module`.  If `ty` is given, declares a "strong" global, which cannot be replaced with a constant binding, otherwise declares a weak global.

See also [`global`](@ref), [`setglobal!`](@ref), [`get_binding_type`](@ref Core.get_binding_type).
