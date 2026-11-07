```julia
ci_has_abi(interp::AbstractInterpreter, code::CodeInstance)
```

Determine whether this CodeInstance is something that could be invoked if interp gave it to the runtime system (either because it already has an ->invoke ptr, or because interp has source that could be compiled).
