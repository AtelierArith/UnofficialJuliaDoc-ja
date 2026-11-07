```julia
info::GlobalAccessInfo <: CallInfo
```

Represents access to a global through runtime reflection, rather than as a manifest `GlobalRef` in the source code. Used for builtins (getglobal/setglobal/etc.) that perform such accesses.
