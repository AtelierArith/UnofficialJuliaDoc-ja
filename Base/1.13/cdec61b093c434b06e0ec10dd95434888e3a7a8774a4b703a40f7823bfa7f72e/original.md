```julia
macroexpand!(m::Module, x; recursive=true, legacyscope=false)
```

Take the expression `x` and return an equivalent expression with all macros removed (expanded) for executing in module `m`, modifying `x` in place without copying. The `recursive` keyword controls whether deeper levels of nested macros are also expanded. The `legacyscope` keyword controls whether legacy macroscope expansion is performed.

This function performs macro expansion without the initial copy step, making it more efficient when the original expression is no longer needed. By default, macroscope expansion is disabled for in-place expansion as it can be called separately if needed.

!!! warning
    This function modifies the input expression `x` in place. Use `macroexpand` if you need to preserve the original expression.


!!! compat "Julia 1.13"
    This function requires at least Julia 1.13.

