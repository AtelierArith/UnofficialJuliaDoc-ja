```
Core.set_binding_type!(module::Module, name::Symbol, [type::Type])
```

Set the declared type of the binding `name` in the module `module` to `type`. Error if the binding already has a type that is not equivalent to `type`. If the `type` argument is absent, set the binding type to `Any` if unset, but do not error.

!!! compat "Julia 1.9"
    This function requires Julia 1.9 or later.

