```julia
isprecompilable(f, argtypes::Tuple{Vararg{Any}})
```

Check, as far as is possible without actually compiling, if the given function `f` can be compiled for the argument tuple (of types) `argtypes`.
