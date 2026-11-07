```julia
infer_compilation_signature(::AbstractInterpreter)::Bool
```

For some call sites (for example calls to varargs methods), the signature to be compiled and executed at run time can differ from the argument types known at the call site. This flag controls whether we should always infer the compilation signature in addition to the call site signature.
