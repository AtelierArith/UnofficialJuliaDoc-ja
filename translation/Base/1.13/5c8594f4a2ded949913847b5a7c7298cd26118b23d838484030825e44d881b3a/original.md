```julia
_eval_using(to::Module, path::Expr)
```

Evaluate the import path to a module and call [`Core._using`](@ref) on it, making its exports available to the `to` module; this is the lowered form of `using A`.

```julia
using A.B            => _module_using(Main, Expr(:., :A, :B))
```

See also [`_using`](@ref Core._using).
