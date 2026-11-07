```julia
Base.Experimental.@MethodTable name
```

Create a new MethodTable in the current module, bound to `name`. This method table can be used with the [`Base.Experimental.@overlay`](@ref) macro to define methods for a function without adding them to the global method table.
