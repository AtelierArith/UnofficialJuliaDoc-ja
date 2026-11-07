```julia
delete_binding(mod::Module, sym::Symbol)
```

Force the binding `mod.sym` to be undefined again, allowing it be redefined. Note that this operation is very expensive, requiring a full scan of all code in the system, as well as potential recompilation of any methods that (may) have used binding information.

!!! warning
    The implementation of this functionality is currently incomplete. Do not use this method on versions that contain this disclaimer except for testing.

