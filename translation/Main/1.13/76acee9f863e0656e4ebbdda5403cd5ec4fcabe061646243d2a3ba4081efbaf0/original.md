```julia
eval(expr)
```

Evaluate an expression in the global scope of the containing module. Every `Module` (except those defined with `baremodule`) has a private 1-argument definition of `eval`, which evaluates expressions in that module, for use inside that module.
