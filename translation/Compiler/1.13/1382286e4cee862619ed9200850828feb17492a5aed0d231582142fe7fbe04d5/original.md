```julia
codegen_cache(interp::AbstractInterpreter) -> Union{Nothing, IdDict{CodeInstance, CodeInfo}}
```

Optionally return a cache associating a `CodeInfo` to a `CodeInstance` that should be added to the JIT for future execution via `invoke(f, ::CodeInstance, args...)`. This cache is used during `typeinf_ext_toplevel`, and may be safely discarded between calls to this function.

By default, a value of `nothing` is returned indicating that `CodeInstance`s should not be added to the JIT. Attempting to execute them via `invoke` will result in an error.
