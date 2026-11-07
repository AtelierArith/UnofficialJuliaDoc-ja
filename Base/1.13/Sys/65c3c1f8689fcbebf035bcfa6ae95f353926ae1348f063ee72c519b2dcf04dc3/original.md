```julia
Sys.JIT::String
```

A string representing the specific Just-In-Time (JIT) compiler being utilized in the current runtime.

# Examples

Currently, this equals `"ORCJIT"` for the LLVM "ORC" ("On-Request Compilation") JIT library:

```jldoctest
julia> Sys.JIT
"ORCJIT"
```

Note: Included in the detailed system information via `versioninfo(verbose=true)`.
